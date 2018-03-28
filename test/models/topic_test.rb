# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#  doc_id           :integer          default(0)
#  channel          :string           default("email")
#  kind             :string           default("ticket")
#  priority         :integer          default(1)
#

require 'test_helper'

class TopicTest < ActiveSupport::TestCase

  should belong_to(:forum)
  should belong_to(:user)
  should belong_to(:doc)
  should have_many(:posts)
  should have_many(:votes)

  should validate_presence_of(:name)
  should validate_length_of(:name).is_at_most(255)

  # forum 1 should exist and be private
  # forum 2 should exist and be private
  test "to_param" do
    assert Topic.find(1).to_param == "1-private-topic"
  end

  test "a new discussion should have status of NEW" do
    topic = build :topic
    assert topic.current_status == "new"
  end

  test "a new topic should cache the creators name" do
    user  = User.first
    topic = create :topic, user: user
    assert topic.user_name == user.name
  end

  test "updating the topic should update the owner name cache" do
    new_user = User.find(7)
    Topic.find(2).update(user: new_user)
    assert_equal Topic.find(2).user_name, new_user.name
  end

  test "trashed messages should be in forum 2, and unassigned" do
    Topic.all.each do |topic|

      topic.trash

      assert topic.assigned_user_id.nil?
      assert topic.forum_id == 2
      assert topic.private?
      assert topic.current_status == 'trash'
      assert_not_nil topic.closed_date
    end
  end

  test "closing a discussion should not unassign it" do
    topic = Topic.find(1)
    topic.close

    assert_not_nil topic.assigned_user_id
    assert topic.current_status == 'closed'
    assert_not_nil topic.closed_date
  end

  test "creating new lowercase name should be saved in sentence_case" do
    name = "something in lowercase"
    topic = create :topic, name: name
    assert_equal name.sentence_case, topic.name
  end

  test "when creating a new topic, any other capitals should be saved as entered" do
    name = "something in lowercase and UPPERCASE"
    topic = create :topic, name: name
    assert_equal name.sentence_case, topic.name
  end

  test "#open? should return true for pending topics and false otherwise" do
    topic = create :topic, current_status: 'open'
    assert_equal true, topic.open?
  end

  test "#open should set the current status of the topic to open/pending" do
    topic = create :topic
    topic.open
    assert_equal 'pending', topic.current_status
  end

  test "#close should set the current_status of the topic to closed, and the assigned_user_id to nil" do
    topic = create :topic
    topic.close
    assert_equal 'closed', topic.current_status
    assert_nil topic.assigned_user_id
  end

  test "#trash should set the current_status of the topic to trash, assigned_user_id to nil, and should create a closed_message post belonging to that topic" do
    topic = create :topic
    t_posts_count = topic.posts.count
    topic.trash
    assert_equal 'trash', topic.current_status
    assert_nil topic.assigned_user_id
    assert_equal t_posts_count + 1, topic.posts.count
  end

  test "#assign_agent should set the current_status of the topic to pending, assigned_user_id to specified user_id, and should create a closed_message post belonging to that topic" do
    topic = create :topic
    bulk_post_attributes = []
    t_posts_count = topic.posts.count
    bulk_post_attributes << {body: I18n.t(:assigned_message, assigned_to: User.find(1).name), kind: 'note', user_id: 1, topic_id: topic.id}
    topics = Topic.where(id: topic.id)
    topics.bulk_agent_assign(bulk_post_attributes, 1)

    topic = Topic.find(topic.id)
    assert_equal 'pending', topic.current_status
    assert_equal 1, topic.assigned_user_id
    assert_equal t_posts_count + 1, topic.posts.count
  end

  test "#assign_group should create an internal note belonging to that topic" do
    topic = create :topic
    bulk_post_attributes = []
    t_posts_count = topic.posts.count
    bulk_post_attributes << {body: I18n.t(:assigned_group, assigned_group: 'test'), kind: 'note', user_id: 1, topic_id: topic.id}
    topics = Topic.where(id: topic.id)
    topics.bulk_group_assign(bulk_post_attributes, 'test')

    topic = Topic.find(topic.id)
    assert_equal t_posts_count + 1, topic.posts.count
  end

  test "public? should return true for a public topic, false if private" do
    assert_equal Topic.find(1).public?, false
    assert_equal Topic.find(4).public?, true
  end

  test "Should be able to assign a topic to a group" do
    topic = create :topic, team_list: 'something'
    assert_equal 'something', topic.team_list.first
  end

  test "Should create a comment thread" do
    assert_difference 'Topic.count', +1 do
      Topic.create_comment_thread(1, 1)
    end
  end

  test "Should be able to merge two topics and copy posts" do
    topica = Topic.create(name: "message A", user_id: 1, forum_id: 1, private: true)
    topica.posts.create(kind: 'first', body: 'message A first', user_id: 1)
    topica.posts.create(kind: 'reply', body: 'message A reply', user_id: 1)
    topicb = Topic.create(name: "message B", user_id: 1, forum_id: 1, private: true)
    topicb.posts.create(kind: 'first', body: 'message B first', user_id: 1)
    topicb.posts.create(kind: 'reply', body: 'message B reply', user_id: 1)

    newtopic = Topic.merge_topics([topica.id, topicb.id])
    assert_equal(4, newtopic.posts.count, "Should be 4 posts")
    assert_equal("MERGED: Message A", newtopic.name, "New topic title is wrong")
    assert_equal("ticket", newtopic.kind, "New topic kind should be 'ticket'")
    assert_equal(1, newtopic.posts.where(kind: 'first').all.count, "There should only be one first post")
    assert_equal('note', newtopic.posts.last.kind, "The last post should be a note")
  end

  # Tests of the from email address method that uses the team email address if present
  test "#from_email_address should return the system email address if no team associated with the ticket" do
    topic = create :topic
    assert_equal "\"Helpy Support\" <inbound.support@yourdomain.com>", topic.from_email_address
  end

  test "#from_email_address should return the team email address if ticket is assigned to group and group email present" do
    tag = ActsAsTaggableOn::Tag.create(
      name: 'tier1',
      description: 'tier one support team',
      color: '',
      email_address: 'tier1@test.com',
      email_name: 'tier one support',
      show_on_helpcenter: false,
      show_on_admin: false
    )
    ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")

    topic = create :topic, name: name, user_id: 1, forum_id: 1, team_list: 'tier1'
    assert_equal "\"tier one support\" <tier1@test.com>", topic.from_email_address
  end

  test "#from_email_address should return the system email if ticket is assigned to group but not group email found" do
    tag = ActsAsTaggableOn::Tag.create(
      name: 'noemailteam',
      description: 'team without address',
      color: '',
      email_address: '',
      email_name: '',
      show_on_helpcenter: false,
      show_on_admin: false
    )
    ActsAsTaggableOn::Tagging.create(tag_id: tag.id, context: "teams")

    topic = create :topic, name: name, user_id: 1, forum_id: 1, team_list: 'noemailteam'
    assert_equal "\"Helpy Support\" <inbound.support@yourdomain.com>", topic.from_email_address
  end

end
