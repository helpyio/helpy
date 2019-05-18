require 'test_helper'

class DeleteTopicJobTest < ActiveJob::TestCase

  test "it should delete a topic and all posts" do
    topic = Topic.find(1)
    assert_difference 'Post.all.count', -3 do
      assert_difference 'Topic.all.count', -1 do
        DeleteTopicJob.perform_now(topic.id)
      end
    end
  end

end
