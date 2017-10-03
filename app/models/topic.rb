# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#  doc_id           :integer          default(0)
#  channel          :string           default("email")
#  kind             :string           default("ticket")
#  priority         :integer          default(1)
#

class Topic < ActiveRecord::Base

  include SentenceCase

  belongs_to :forum, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true, touch: true
  belongs_to :doc, counter_cache: true, touch: true
  belongs_to :assigned_user, class_name: 'User'

  has_many :posts, :dependent => :delete_all
  accepts_nested_attributes_for :posts

  has_many :votes, :as => :voteable
  has_attachments  :screenshots, accept: [:jpg, :png, :gif, :pdf, :txt, :rtf, :doc, :docx, :ppt, :pptx, :xls, :xlsx, :zip]

  paginates_per 25

  include PgSearch
  multisearchable :against => [:id, :name, :post_cache],
                  :if => :public?

  pg_search_scope :admin_search,
                  against: [:id, :name, :user_name, :current_status, :post_cache],
                  associated_against: {
                    teams: [:name]
                  }

  # various scopes
  scope :recent, -> { order('created_at DESC').limit(8) }
  scope :open, -> { where(current_status: "open") }
  scope :unread, -> { where("assigned_user_id = ? OR current_status = ?", nil, "new").where.not(current_status: 'closed') }
  scope :pending, -> { where(current_status: "pending") }
  scope :mine, -> (user) { where(assigned_user_id: user) }
  scope :closed, -> { where(current_status: "closed") }
  scope :spam, -> { where(current_status: "spam")}
  scope :assigned, -> { where.not(assigned_user_id: nil) }

  scope :chronologic, -> { order('updated_at DESC') }
  scope :reverse, -> { order('updated_at ASC') }
  scope :by_popularity, -> { order('points DESC') }
  scope :active, -> { where(current_status: %w(open pending)) }
  scope :undeleted, -> { where.not(current_status: 'trash') }
  scope :front, -> { limit(6) }
  scope :for_doc, -> { where("doc_id= ?", doc)}

  # provided both public and private instead of one method, for code readability
  scope :isprivate, -> { where.not(current_status: 'spam').where(private: true)}
  scope :ispublic, -> { where.not(current_status: 'spam').where(private: false)}

  # may want to get rid of this filter:
  # before_save :check_for_private
  before_create :add_locale

  before_save :cache_user_name
  acts_as_taggable_on :tags, :teams

  validates :name, presence: true, length: { maximum: 255 }
  # validates :user_id, presence: true

  enum priority: { low: 0, normal: 1, high: 2, very_high: 3 }

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def email_subject
    "##{self.id} | #{self.name}"
  end

  def assigned?
    self.assigned_user_id.present?
  end

  def open?
    self.current_status == "open"
  end

  def open
    self.current_status = "pending"
    self.save
  end

  def reopen(user_id = 2)
    self.posts.create(body: I18n.t(:reopen_message, user_name: User.find(user_id).name), kind: 'note', user_id: user_id)
    self.current_status = "open"
    self.save
  end

  def self.bulk_reopen(post_attributes)
    Post.bulk_insert values: post_attributes
    self.update_all(current_status: 'open')
  end

  def close(user_id = 2)
    self.posts.create(body: I18n.t(:closed_message, user_name: User.find(user_id).name), kind: 'note', user_id: user_id)
    self.current_status = "closed"
    self.closed_date = Time.current
    self.save
  end

  def self.bulk_close(post_attributes)
    Post.bulk_insert values: post_attributes
    self.update_all(current_status: 'closed', closed_date: Time.current)
  end

  def trash(user_id = 2)
    self.posts.create(body: I18n.t(:trash_message, user_name: User.find(user_id).name), kind: 'note', user_id: user_id)
    self.current_status = "trash"
    self.closed_date = Time.current
    self.forum_id = 2
    self.private = true
    self.assigned_user_id = nil
    self.save
  end

  def self.bulk_trash(post_attributes)
    Post.bulk_insert values: post_attributes
    self.update_all(current_status: 'trash', forum_id: 2, private: true, assigned_user_id: nil, closed_date: Time.current)
  end

  def assign(user_id=2, assigned_to)
    self.posts.create(body: I18n.t(:assigned_message, assigned_to: User.find(assigned_to).name), kind: 'note', user_id: user_id)
    self.assigned_user_id = assigned_to
    self.current_status = 'pending'
    self.save
  end

  def self.bulk_agent_assign(post_attributes, assigned_to)
    Post.bulk_insert values: post_attributes
    self.update_all(assigned_user_id: assigned_to, current_status: 'pending')
  end

  def self.bulk_group_assign(post_attributes, assigned_group)
    Post.bulk_insert values: post_attributes
    all.each do |t|
      t.team_list = assigned_group
      t.save
    end
  end

  # DEPRECATED updates the last post date, called when a post is made
  def self.last_post
    Topic.post(:first, :order => 'updated_at DESC')
  end

  #Callback method to check and see if this topic is in a private forum
  def check_for_private
    #association is not working
    f = Forum.find(self.forum_id)
    self.private = true if f.private?
  end

  def public?
    # Note: We assume forum_ids 1,2,3 are seed data
    forum_id >= 3 && !private?
  end

  def create_topic_with_user(params, current_user)
    self.user = current_user ? current_user : User.find_by_email(params[:topic][:user][:email])

    unless self.user #User not found, lets build it
      self.build_user(params[:topic].require(:user).permit(:email, :name)).signup_guest
    end
    self.user.persisted? && self.save
  end

  def create_topic_with_webhook_user(params)
    self.user = User.find_by_email(params['customer']['emailAddress'])
    unless self.user #User not found, lets craete it from olark params
      @token, enc = Devise.token_generator.generate(User, :reset_password_token)

      @user = self.build_user
      @user.reset_password_token = enc
      @user.reset_password_sent_at = Time.now.utc

      @user.name = params['customer']['fullName']
      @user.login = params['customer']['emailAddress'].split("@")[0]
      @user.email = params['customer']['emailAddress']
      # @user.home_phone = params[:topic][:user][:home_phone]
      @user.password = User.create_password
      @user.save
    end
    self.user.persisted? && self.save
  end

  def self.create_comment_thread(doc_id, user_id)
    @doc = Doc.find(doc_id)
    @user = User.find(user_id)
    Topic.create!(
      name: "Discussion on #{@doc.title}",
      private: false,
      forum_id: Forum.for_docs.first.id,
      user_id: @user.id,
      doc_id: @doc.id
    )
  end

  def self.merge_topics(topic_ids, user_id=2)

    @merge_topics = Topic.where(id: topic_ids)
    @topic = @merge_topics.first.dup
    @topic.name = "MERGED: #{@merge_topics.first.name}"
    topics_merged = ""

    if @topic.save
      @merge_topics.each_with_index do |t, i|

        if i == 0
          @topic.posts << t.posts
        else
          @topic.posts << t.posts.where.not(kind: 'first').all
        end
        topics_merged << "#{t.name}\n"
      end

      @topic.posts.create(
          body: "#{topics_merged} were merged to create this discussion",
          kind: "note",
          user_id: user_id,
      )

      @merge_topics.each do |t|
        t.trash
      end

      return @topic
    end
  end

  def from_email_address
    system_from_email = %("#{AppSettings['settings.site_name']}" <#{AppSettings['email.admin_email']}>)
    return system_from_email if self.team_list.blank?

    team = ActsAsTaggableOn::Tag.where('lower(name) = ?', self.team_list.first.downcase).first
    if team.email_address.present?
      %("#{team.email_name}" <#{team.email_address}>)
    else
      system_from_email
    end
  end

  private

  def cache_user_name
    if self.user.name.present?
      self.user_name = self.user.name
    else
      "NA"
    end
  end

  def add_locale
    self.locale = I18n.locale
  end
end
