class EmptyTrashJob < ActiveJob::Base
  queue_as :default

  def perform
    topics = Topic.where(current_status: 'deleting').all
    topics.each do |topic|
      DeleteTopicJob.perform_later(topic.id)
    end
  end
end
