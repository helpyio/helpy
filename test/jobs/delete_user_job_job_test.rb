require 'test_helper'

class DeleteUserJobTest < ActiveJob::TestCase

  test "all user articles should be deleted" do
    u = User.find(9)
    assert_difference 'Topic.all.count', -7 do
      assert_difference "Post.all.count", -9 do
        DeleteUserJob.perform_now(u.id)
      end
    end
    assert_equal 0, Topic.where(user_id: u.id).count
    assert_equal 0, Post.where(user_id: u.id).count
    assert_equal 0, ApiKey.where(user_id: u.id).count
  end

end
