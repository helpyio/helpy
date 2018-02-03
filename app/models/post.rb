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

  # This is used to skip the callbacks when importing (ie. we don't want to send
  # emails to everyone while importing)
  attr_accessor :importing
  attr_accessor :resolved

  belongs_to :topic, counter_cache: true, touch: true
  belongs_to :user, touch: true
  has_many :votes, as: :voteable
  has_attachments :screenshots, accept: %i[jpg png gif pdf]
  has_many :flags
  mount_uploaders :attachments, AttachmentUploader

  validates :body, length: { maximum: 10_000 }
  before_validation :truncate_body
  validates :kind, :user, :user_id, :body, presence: true

  after_create  :update_waiting_on_cache, unless: :importing
  after_create  :assign_on_reply, unless: :importing
  after_commit  :notify, on: :create, unless: :importing
  after_save :update_topic_cache

  scope :all_by_topic, ->(topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }
  scope :active, -> { where(active: true) }
  scope :ispublic, -> { where.not(kind: 'note') }
  scope :chronologic, -> { order('created_at ASC') }
  scope :reverse, -> { order('created_at DESC') }
  scope :by_votes, -> { order('points DESC') }
  scope :notes, -> { where(kind: 'note') }

  # updates the last post date for both the forum and the topic
  # updates the waiting on cache
  def update_waiting_on_cache
    status = topic.current_status
    waiting_on = topic.waiting_on

    # unless status == 'closed' || status == 'trash'
    unless status == 'trash'
      logger.info('private message, update waiting on cache')
      status = topic.current_status
      if user && user.is_agent?
        logger.info('waiting on user')
        waiting_on = "user"
        status = "open"
      else
        logger.info('waiting on admin')
        waiting_on = "admin"
        status = "pending" unless topic.current_status == 'new'
      end
    end

    topic.update(last_post_date: Time.current, waiting_on: waiting_on, current_status: status)
    topic.forum.update(last_post_date: Time.current)
  end

  # updates cache of post content used in search
  def update_topic_cache
    unless kind == 'note'
      current_cache = topic.post_cache
      topic.update(post_cache: "#{current_cache} #{body}")
    end
  end

  # Assign the parent topic if not assigned and this is a reply by admin
  # or agents
  def assign_on_reply
    if topic.assigned_user_id.nil?
      topic.assigned_user_id = user.is_agent? ? user_id : nil
    end
  end

  # send notification to agents/admins if configured
  # this logic resides in the modal because we want the same actions
  # regardless of how the post is created (web, email, api, etc)
  def notify
    # Handle new private ticket notification:
    if kind == "first" && topic.private?
      NotificationMailer.new_private(topic_id).deliver_later
    # Handles new public ticket notification:
    elsif kind == "first" && topic.public?
      NotificationMailer.new_public(topic_id).deliver_later

    # Handles customer reply notification:
    elsif kind == "reply" && user_id == topic.user_id && topic.private?
      NotificationMailer.new_reply(topic_id).deliver_later

    # Reply from user back to the system
    elsif kind == "reply" && user_id != topic.user_id && topic.private?
      I18n.with_locale(email_locale) do
        PostMailer.new_post(id).deliver_later
      end
    end
  end

  def email_locale
    return I18n.locale if kind == 'first'
    topic.locale.nil? ? I18n.locale : topic.locale.to_sym
  end

  def importing?
    importing || false
  end

  private

  def truncate_body
    self.body = body.truncate(10_000) unless body.blank?
  end
end
