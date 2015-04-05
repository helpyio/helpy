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

  after_save :update_last_post_date_cache
  after_save :update_topic_cache
  after_save :send_message

  scope :all_by_topic, -> (topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }


  #updates the last post date for both the forum and the topic
  def update_last_post_date_cache
    self.topic.update_attribute('last_post_date', Time.now)
    self.topic.forum.update_attribute('last_post_date', Time.now)
  end

  #updates cache of post content used in search
  def update_topic_cache
    current_cache = self.topic.post_cache
    self.topic.update(post_cache: "#{current_cache} #{self.body}")
  end

  def send_message
    # TODO deliver/create a firstmessage to deliver on the initial post
    #Should only send when admin posts, not when user replies
    if self.user.admin?
      logger.info("admin is replying to message, so email")
      TopicMailer.new_post(self.topic).deliver_now if self.topic.posts.count > 1 && Settings.send_email == true && self.topic.private == true
    else
      logger.info("reply is not from admin, don't email")
    end
  end

end
