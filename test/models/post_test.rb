# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  topic_id    :integer
#  user_id     :integer
#  body        :text
#  kind        :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  points      :integer          default(0)
#  attachments :string           default([]), is an Array
#  cc          :string
#  bcc         :string
#  raw_email   :text
#

require 'test_helper'

class PostTest < ActiveSupport::TestCase

  should belong_to(:topic)
  should belong_to(:user)
  should have_many(:votes)
  should have_many(:flags)

  should validate_presence_of(:body)
  should validate_presence_of(:kind)
  should validate_presence_of(:user)

  # first post should be kind first
  # post belonging to a topic with multiple posts should be a reply

  test "a new post should also add to the topic cache field for searchability" do
    @user = User.first
    assert_difference 'Topic.count', 1 do
      @topic = create :topic, user: @user, forum_id: 1
    end
    assert_difference 'Post.count', 1 do
      @post  = create :post, topic: @topic, user: @user
    end

    assert @post.topic.post_cache == " #{@post.body}"
  end

  test "marking a post inactive should remove it from the topic cache" do
    @user = User.first

    @topic = create :topic, user: @user, forum_id: 1
    @post = create :post, topic: @topic, user: @user
    assert @post.topic.post_cache == " #{@post.body}"

    @post.active = false
    @post.save
    assert @post.topic.post_cache != " #{@post.body}"
  end

  test "marking a post active should add it to the topic cache" do

    @post = Post.find(4)
    @post.active = true
    @post.save

    assert @post.topic.post_cache.include? @post.body

  end

  test "a post of kind internal note should not be added to the topic cache" do

    @post = Post.find(5)
    refute @post.topic.post_cache.include? @post.body

  end

  # Topics should be autoassigned(AA) when they are unassigned and a reply is made by an admin
  # --------------------------------------------------------------------------------------

  # Should not AA when already assigned
  # Should not AA when a note is posted
  # Should not AA when the reply is posted by a non admin
  # Should AA when a reply is posted by an admin

  # Note: decided that public posts should assigned if an admin replies to the thread

  test "Should not AA when topic is already assigned" do
    topic = Topic.find(1) #already assigned topic
    post = create :post, topic: topic, kind: "reply"
    assert_not_equal(5, topic.assigned_user_id, "Topic assignment should not have changed")
  end

  test "Should not AA when an internal note is posted" do
    topic = Topic.find(4) #unassigned public topic
    post = create :post, topic: topic, kind: "note"
    assert_not_equal(1, topic.assigned_user_id, "Internal note should not set assignment")

    topic = Topic.find(6) #unassigned private topic
    post = create :post, topic: topic, kind: "note"
    assert_not_equal(1, topic.assigned_user_id, "Internal note should not set assignment")
  end

  test "Should not AA when the reply is posted by a non admin" do
    topic = Topic.find(6) #unassigned topic
    post = create :post, topic: topic, kind: "reply", user_id: 2 #non admin user
    assert_not_equal(2, topic.assigned_user_id, "Topic assignment should not have changed")
  end

  test "Should AA when a reply is posted by an admin" do
    topic = Topic.find(4) #unassigned topic
    post = create :post, topic: topic, kind: "reply", user_id: 1
    assert_equal(1, topic.assigned_user_id, "Topic should be assigned to user 1")
  end

  # Notifications Specs

  test "Should send an admin notification of a new private topic created, if enabled" do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      @topic = create :topic, forum_id: 1, user_id: 2, name: "A test topic", private: true
      @topic.posts.create!(
        user_id: 2,
        body: "This is the first post",
        kind: "first"
      )
    end
  end

  test "Should send an admin notification of a new public topic, if enabled" do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      @topic = create :topic, forum_id: 4, user_id: 2, name: "A test topic", private: false
      @topic.posts.create!(
        user_id: 2,
        body: "This is the first message",
        kind: "first"
      )
    end
  end

  test "Should send an admin notification of a new private reply, if enabled" do
    # We expect three notifications- one goes to the agent to tell them there is a
    # new private discussion, the second notifies the customer of the agents
    # reply and the final notifies the agent of the final customer reply
    assert_difference('ActionMailer::Base.deliveries.size', 3) do
      @topic = create :topic, forum_id: 1, user_id: 2, name: "A test topic", private: true
      @topic.posts.create!(
        user_id: 2,
        body: "This is the first message from the customer",
        kind: "first"
      )
      @topic.posts.create!(
        user_id: 1,
        body: "This is the first reply from admin",
        kind: "reply"
      )
      @topic.posts.create!(
        user_id: 2,
        body: "This is the second reply from the customer",
        kind: "reply"
      )
    end
  end

  test "Should NOT send any notifications if a new internal note" do
    assert_difference('ActionMailer::Base.deliveries.size', 1) do
      @topic = create :topic, forum_id: 1, user_id: 2, name: "A test topic", private: true
      @topic.posts.create!(
        user_id: 2,
        body: "This is the first message",
        kind: "first"
      )
      @topic.posts.create!(
        user_id: 1,
        body: "This is the first note",
        kind: "note"
      )
    end
  end

  # test "Should truncate body length if greater than 10,000" do
  #   body   = "0" * 10001
  #   @user  = User.first
  #   @topic = create :topic, user: @user, forum_id: 1
  #   @post  = create :post, topic: @topic, user: @user, body: body
  #
  #   assert_equal @post.body.size, 10_000
  # end

end
