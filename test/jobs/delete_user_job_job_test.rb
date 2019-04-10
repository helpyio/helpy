require 'test_helper'

class DeleteUserJobTest < ActiveJob::TestCase

  test "all user articles should be deleted" do
    u = User.find(9)
    # calculate the total posts to be removed by adding all posts from threads created
    # by the user plus any other individual posts
    users_topics = u.topics.collect{|t| t.posts}.count
    users_posts = 0
    Topic.where().not(user: u).each do |topic|
      users_posts += topic.posts.where(user: u).count
    end
    posts_to_be_removed = users_topics + users_posts
    assert_difference 'Topic.all.count', (0-u.topics.count) do
      assert_difference "Post.all.count", 0-posts_to_be_removed do
        DeleteUserJob.perform_now(u.id)
      end
    end
    assert_equal 0, Topic.where(user_id: u.id).count
    assert_equal 0, Post.where(user_id: u.id).count
    assert_equal 0, ApiKey.where(user_id: u.id).count
  end

end
