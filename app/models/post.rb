# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  points     :integer          default(0)
#

class Post < ActiveRecord::Base

  attr_accessor :reply_id

  belongs_to :topic, counter_cache: true, touch: true
  belongs_to :user, touch: true
  has_many :votes, :as => :voteable
  has_attachments :screenshots, accept: [:jpg, :png, :gif, :pdf]

  validates :body, presence: true, length: { maximum: 10_000 }
  validates :kind, presence: true
  validates :user_id, presence: true

  after_create  :update_waiting_on_cache
  after_create  :assign_on_reply
  after_save  :update_topic_cache

  scope :all_by_topic, -> (topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }
  scope :active, -> { where(active: true) }
  scope :ispublic, -> { where.not(kind: 'note') }
  scope :chronologic, -> { order('created_at ASC') }
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

end
