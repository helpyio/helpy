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
#

class Topic < ActiveRecord::Base

  include SentenceCase

  belongs_to :forum, counter_cache: true, touch: true
  belongs_to :user, counter_cache: true, touch: true
  belongs_to :assigned_user, class_name: 'User'

  has_many :posts, :dependent => :delete_all
  has_many :votes, :as => :voteable
  has_attachments  :screenshots, accept: [:jpg, :png, :gif]

  paginates_per 25

  include PgSearch
  multisearchable :against => [:id, :name, :post_cache],
                  :if => :public

  pg_search_scope :admin_search,
                  against: [:id, :name, :user_name, :current_status, :post_cache]

  # various scopes
  scope :recent, -> { order('created_at DESC').limit(8) }
  scope :open, -> { where(current_status: "open") }
  scope :unread, -> { where(current_status: "new") }
  scope :pending, -> { where(current_status: "pending") }
  scope :mine, -> (user) { where(assigned_user_id: user) }
  scope :closed, -> { where(current_status: "closed") }
  scope :spam, -> { where(current_status: "spam")}

  scope :chronologic, -> { order('updated_at DESC') }
  scope :by_popularity, -> { order('points DESC') }
  scope :active, -> { where(current_status: %w(open pending)) }
  scope :undeleted, -> { where.not(current_status: 'trash') }
  scope :front, -> { limit(6) }

  # provided both public and private instead of one method, for code readability
  scope :isprivate, -> { where.not(current_status: 'spam').where(private: true)}
  scope :ispublic, -> { where.not(current_status: 'spam').where(private: false)}

  # may want to get rid of this filter:
  # before_save :check_for_private
  before_create :cache_user_name
  before_create :add_locale

  # acts_as_taggable

  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  def to_param
    "#{id}-#{name.parameterize}"
  end

  def email_subject
    "##{self.id} | #{self.name}"
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

  def close(user_id = 2)
    self.posts.create(body: I18n.t(:close_message, user_name: User.find(user_id).name), kind: 'note', user_id: user_id)
    self.current_status = "closed"
    self.closed_date = Time.now
    self.assigned_user_id = nil
    self.save
  end

  def trash(user_id = 2)
    self.posts.create(body: I18n.t(:trash_message, user_name: User.find(user_id).name), kind: 'note', user_id: user_id)
    self.current_status = "trash"
    self.closed_date = Time.now
    self.forum_id = 2
    self.private = true
    self.assigned_user_id = nil
    self.save
  end

  def assign(user_id=2, assigned_to)
    self.posts.create(body: I18n.t(:assigned_message, assigned_to: User.find(assigned_to).name), kind: 'note', user_id: user_id)
    self.assigned_user_id = assigned_to
    self.current_status = 'pending'
    self.save
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

  # TODO: This is better named 'public?'
  def public
    # Note: We assume forum_ids 1,2,3 are seed data
    forum_id >= 3 && !private?
  end

  private

  def cache_user_name
    self.user_name = self.user.name
  end

  def add_locale
    self.locale = I18n.locale
  end
end
