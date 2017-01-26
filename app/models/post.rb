# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  topic_id    :integer
#  user_id     :integer
#  body        :text
#  kind        :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  points      :integer          default(0)
#  attachments :string           default([]), is an Array
#  cc          :string
#  bcc         :string
#  raw_email   :text
#

class Post < ActiveRecord::Base

  attr_accessor :reply_id

  belongs_to :topic, counter_cache: true, touch: true
  belongs_to :user, touch: true
  has_many :votes, :as => :voteable
  has_attachments :screenshots, accept: [:jpg, :png, :gif, :pdf]
  has_many :flags
  mount_uploaders :attachments, AttachmentUploader

  validates :body, length: { maximum: 10_000 }
  before_validation :truncate_body
  validates :kind, :user, :user_id, :body, presence: true


  after_create  :update_waiting_on_cache
  after_create  :assign_on_reply
  after_commit  :notify, on: :create
  after_save  :update_topic_cache

  scope :all_by_topic, -> (topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }
  scope :active, -> { where(active: true) }
  scope :ispublic, -> { where.not(kind: 'note') }
  scope :chronologic, -> { order('created_at ASC') }
  scope :reverse, -> { order('created_at DESC') }
  scope :by_votes, -> { order('points DESC')}

  attr_accessor :resolved

  #updates the last post date for both the forum and the topic
  #updates the waiting on cache
  def update_waiting_on_cache

    status = self.topic.current_status
    waiting_on = self.topic.waiting_on

    #unless status == 'closed' || status == 'trash'
    unless status == 'trash'
      logger.info('private message, update waiting on cache')
      status = self.topic.current_status
      if self.user && self.user.is_agent?
        logger.info('waiting on user')
        waiting_on = "user"
        status = "open"
      else
        logger.info('waiting on admin')
        waiting_on = "admin"
        status = "pending" unless self.topic.current_status == 'new'
      end
    end

    self.topic.update(last_post_date: Time.current, waiting_on: waiting_on, current_status: status)
    self.topic.forum.update(last_post_date: Time.current)
  end

  #updates cache of post content used in search
  def update_topic_cache
    unless self.kind == 'note'
      current_cache = self.topic.post_cache
      self.topic.update(post_cache: "#{current_cache} #{self.body}")
    end
  end

  # Assign the parent topic if not assigned and this is a reply by admin
  # or agents
  def assign_on_reply
    if self.topic.assigned_user_id.nil?
      self.topic.assigned_user_id = self.user.is_agent? ? self.user_id : nil
    end
  end

  # send notification to agents/admins if configured
  # this logic resides in the modal because we want the same actions
  # regardless of how the post is created (web, email, api, etc)
  def notify
    # Handle new private ticket notification:
    if self.kind == "first" && self.topic.private?
      NotificationMailer.new_private(self.topic_id).deliver_later
    # Handles new public ticket notification:
    elsif self.kind == "first" && self.topic.public?
      NotificationMailer.new_public(self.topic_id).deliver_later

    # Handles customer reply notification:
    elsif self.kind == "reply" && self.user_id == self.topic.user_id && self.topic.private?
      NotificationMailer.new_reply(self.topic_id).deliver_later

    # Reply from user back to the system
    elsif self.kind == "reply" && self.user_id != self.topic.user_id && self.topic.private?
      I18n.with_locale(self.email_locale) do
        PostMailer.new_post(id).deliver_later
      end
    end
  end

  def email_locale
    return I18n.locale if self.kind == 'first'
    self.topic.locale.nil? ? I18n.locale : self.topic.locale.to_sym
  end

  private

    def truncate_body
      self.body = body.truncate(10_000) unless body.blank?
    end

end
