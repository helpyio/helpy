class Post < ActiveRecord::Base

  belongs_to :topic, :counter_cache => true
  belongs_to :user

  validates_presence_of :body
  validates_length_of :body, :maximum => 10000

  after_save :update_last_post_date_cache

#  named_scope :all_by_topic, lambda { |topic|
#            { :conditions => ["topic_id = ?", topic], :order => 'updated_at ASC', :include => :user }
#  }
  scope :all_by_topic, -> (topic) { where("topic_id = ?", topic).order('updated_at ASC').include(user) }


  #updates the last post date for both the forum and the topic
  def update_last_post_date_cache
    self.topic.update_attribute('last_post_date', Time.now)
    self.topic.forum.update_attribute('last_post_date', Time.now)
  end


end
