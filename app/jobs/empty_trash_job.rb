class EmptyTrashJob < ActiveJob::Base
  queue_as :default

  def perform
    topics = Topic.trash.all
    topics.each do |topic|
      DeleteTopicJob.perform_later(topic.id)
    end
  end
end
