require 'test_helper'

class NotificationTest < ActiveSupport::TestCase

  def create_topic
    @topic = create :topic, forum_id: 1, user_id: 2, name: "A test topic", private: true
    @topic.posts.create!(
      user_id: 2,
      body: "This is the first post",
      kind: "first"
    )
  end

  # Internal notification test cases
  test "when a new topic is added, all agents should be notified" do
    create_topic
    assert_equal 3, Notification.count
  end

  test "when an agent adds a note to a ticket, they should become a follower" do
    create_topic
    assert_difference "Follower.count", +1 do
      @topic.posts.create!(
        user_id: 6,
        body: "This is the first post",
        kind: "note"
      )
    end
  end

  test "when an agent replies to a ticket, they should become a follower" do
    create_topic
    assert_difference "Follower.count", +1 do
      @topic.posts.create!(
        user_id: 6,
        body: "This is the first reply",
        kind: "reply"
      )
    end
  end

  test "when an agent replies, followers should be notified" do
    create_topic
    @topic.followers.create(user_id: 1)
    @topic.followers.create(user_id: 5)
    assert_difference "Notification.count", +2 do
      @topic.posts.create!(
        user_id: 6,
        body: "This is an agent reply",
        kind: "reply"
      )
    end
  end

  test "when an agent replies, they should NOT be notified" do
    create_topic
    assert_difference "Notification.count", +0 do
      @topic.posts.create!(
        user_id: 6,
        body: "This is an agent reply",
        kind: "reply"
      )
    end
  end

  test "creating a note with #follow should add the user to the followers" do
    create_topic
    assert_difference "Follower.count", +1 do
      @topic.posts.create!(
        user_id: 6,
        body: "#follow",
        kind: "note"
      )
    end
  end

  test "creating a note with #unfollow should remove the user to the followers" do
    create_topic
    @topic.followers.create(user_id: 1)
    @topic.followers.create(user_id: 6)
    assert_difference "Follower.count", -1 do
      @topic.posts.create!(
        user_id: 6,
        body: "#unfollow",
        kind: "note"
      )
    end
  end

  test "when a customer replies, followers should be notified" do
    create_topic
    @topic.followers.create(user_id: 1)
    @topic.followers.create(user_id: 6)
    # Add agent reply
    assert_difference "Notification.count", +2 do
      @topic.posts.create!(
        user_id: 5,
        body: "This is an admin reply",
        kind: "reply"
      )
    end
    # Add customer re-reply
    assert_difference "Notification.count", +3 do
      @topic.posts.create!(
        user_id: 2,
        body: "This is an agent reply",
        kind: "reply"
      )
    end
  end

  test "mentioning another agent should add them as a follower" do
    create_topic
    assert_difference "Follower.count", +1 do
      @topic.posts.create!(
        user_id: 6,
        body: "pinging @agent",
        kind: "note"
      )
    end
  end
end
