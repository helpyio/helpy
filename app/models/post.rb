# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Post < ActiveRecord::Base

  belongs_to :topic, :counter_cache => true
  belongs_to :user

  validates_presence_of :body
  validates_length_of :body, :maximum => 10000

  after_create :update_waiting_on_cache
  after_save :update_topic_cache
  #after_save :send_message

  scope :all_by_topic, -> (topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }


  #updates the last post date for both the forum and the topic
  #updates the waiting on cache
  def update_waiting_on_cache

    status = self.topic.current_status
    waiting_on = self.topic.waiting_on

    unless status == 'closed'
      logger.info('private message, update waiting on cache')
      status = self.topic.current_status
      if self.user.admin?
        logger.info('waiting on user')
        waiting_on = "user"
        status = "open"
      else
        logger.info('waiting on admin')
        waiting_on = "admin"
        status = "pending" unless self.topic.current_status == 'new'
      end
    end

    self.topic.update(last_post_date: Time.now, waiting_on: waiting_on, current_status: status)
    self.topic.forum.update(last_post_date: Time.now)
  end

  #updates cache of post content used in search
  def update_topic_cache
    current_cache = self.topic.post_cache
    self.topic.update(post_cache: "#{current_cache} #{self.body}")
  end


end
