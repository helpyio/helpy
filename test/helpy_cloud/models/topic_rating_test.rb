require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  test "hashed_id should hash a topic id" do
    hash = Topic.first.hashed_id
    assert_equal Topic.first.id, Topic.unhashed_id(hash)
  end

end
