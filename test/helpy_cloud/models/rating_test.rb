require 'test_helper'

class RatingTest < ActiveSupport::TestCase
  should belong_to(:topic)

  test "creating a new rating should generate a note" do
    assert_difference('Post.count', +1) do
      Rating.create(topic_id: 1, score: 3)
    end
  end
end
