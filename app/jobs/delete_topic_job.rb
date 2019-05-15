class DeleteTopicJob < ActiveJob::Base
  queue_as :default

  def perform(topic_id)
    topic = Topic.find(topic_id)
    topic.destroy
  end
end
