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
#  doc_id           :integer          default(0)
#  locale           :string
#

require 'test_helper'

class API::V1::TopicsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Topics Key", user: @user)
    @default_params = { token: @api_key.access_token }

    # Create a group restricted agent and topic

    @group_agent = users(:agent)
    @group_agent.team_list = "something"
    @group_agent.save!

    @group_agent_key = ApiKey.create(name: "Restricted Agent Key", user: @group_agent)
    @group_agent_default_params = { token: @group_agent_key.access_token }
  end

  # TEST TICKET ENDPOINTS

  test "an unauthenticated user should receive an unauthorized message" do
    get '/api/v1/tickets/status/pending.json'

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return tickets by status" do
    get '/api/v1/tickets/status/pending.json', @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == Topic.pending.count, "Only #{objects.length} returned out of #{Topic.active.count} topics"
  end

  test "a group restricted agent should only see tickets their group is assigned to" do
    Topic.create!(name: "Something interesting", user_id: 1, forum_id: 1, team_list: "something")

    get '/api/v1/tickets/status/new.json', @group_agent_default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == 1, "Only #{objects.length} returned out of #{Topic.active.count} topics"
  end

  test "a group restricted agent should not see tickets not assigned to their group" do
    Topic.create!(name: "Something interesting", user_id: 1, forum_id: 1, team_list: "somethingelse")

    get '/api/v1/tickets/status/new.json', @group_agent_default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == 0, "Only #{objects.length} returned out of #{Topic.active.count} topics"
  end

  test "an API user should be able to return tickets for a user" do
    user = User.find(2)

    get "/api/v1/tickets/user/#{user.id}", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == Topic.where(user_id: user.id, private: true).count, "Only #{objects.length} returned out of #{Topic.active.count} topics"
  end

  test "an API user should be able to return a specific ticket and its thread by ID" do
    ticket = Topic.create!(name: "Something interesting", user_id: 1, forum_id: 1, team_list: "somethingelse")

    get "/api/v1/tickets/#{ticket.id}.json", @group_agent_default_params

    # Check OK
    assert_equal 401, last_response.status, "Response was #{last_response.status}, expected 401"
  end

  test "a group restricted agent should not see a ticket not assigned to their group" do
    ticket = Topic.find(2)

    get "/api/v1/tickets/#{ticket.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == ticket.id
    assert object['name'] == ticket.name
    assert object['posts'].count == ticket.posts.count
  end

  test "an API user should be able to create a ticket" do
    user = User.find(2)

    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_id: user.id,
      tag_list: 'tag1, tag2',
    }

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal 1, object['forum_id']
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
    assert_equal "api", object['channel']
    assert_equal 2, object['tag_list'].count
  end

  test "an API user should be able to create a ticket by email" do
    user = User.find(2)

    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_email: user.email,
      tag_list: 'tag1, tag2',
    }

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert_equal 1, object['forum_id']
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
    assert_equal "api", object['channel']
    assert_equal 2, object['tag_list'].count
  end

  test "an API user should be able to create a ticket by mixed case email" do
    user = User.find(2)

    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_email: "Scott.Miller@test.com",
      tag_list: 'tag1, tag2',
    }

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert_equal 1, object['forum_id']
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
    assert_equal "api", object['channel']
    assert_equal 2, object['tag_list'].count
  end

  test "an API user should not be able to create a ticket if user_id or user_email not supplied" do
    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      tag_list: 'tag1, tag2',
    }

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert_equal 403, last_response.status
    assert object['error'] == 'Required field not present. user_id or user_email and user_name is missing'
  end

  test "a non-registered API user should not be able to create a ticket by email if name not provided" do
    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_email: 'not-registered-test-user@my-test-domain.com',
      tag_list: 'tag1, tag2',
    }

    assert_nil User.find_by(email: params[:user_email])

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert_equal 401, last_response.status
    assert object['error'] == 'User not registered. Insufficient access priviledges.'
  end

  test "a non-registered API user should be registered and able to create a ticket by email if name provided" do
    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_email: 'not-registered-test-user@my-test-domain.com',
      user_name: 'User Not Registered',
      tag_list: 'tag1, tag2',
    }

    assert_nil User.find_by(email: params[:user_email])

    post '/api/v1/tickets.json', @default_params.merge(params)

    assert_not_nil User.find_by(email: params[:user_email])

    object = JSON.parse(last_response.body)
    assert_equal 1, object['forum_id']
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
    assert_equal "api", object['channel']
    assert_equal 2, object['tag_list'].count
  end

  test "a non-registered API user should not be registered and should not create a ticket by email if provided name is invalid" do
    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_email: 'not-registered-test-user@my-test-domain.com',
      user_name: 'User N0t R3gist3r3d',
      tag_list: 'tag1, tag2',
    }

    assert_nil User.find_by(email: params[:user_email])

    post '/api/v1/tickets.json', @default_params.merge(params)

    assert_nil User.find_by(email: params[:user_email])

    object = JSON.parse(last_response.body)
    assert_equal 403, last_response.status
    assert object['error'].include?('Ticket not created. User could not be registered')
  end

  test "an API user should be able to assign a ticket" do
    user = User.find(1)
    ticket = Topic.find(2)

    params = {
      assigned_user_id: user.id
    }

    post "/api/v1/tickets/assign/#{ticket.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert object['assigned_user_id'] == 1
  end

  test "an API user should be able to add tags to a ticket" do
    user = User.find(1)
    ticket = Topic.find(2)

    params = {
      tag_list: 'tag1, tag2'
    }

    post "/api/v1/tickets/update_tags/#{ticket.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert_equal ['tag1', 'tag2'], object['tag_list']
    assert_equal 2, object['tag_list'].count
  end

  test "an API user should be able to move a private ticket to a public forum" do
    ticket = Topic.find(2)

    params = {
      forum_id: 3
    }

    post "/api/v1/tickets/update_forum/#{ticket.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert object['forum_id'] == 3
  end

  # TEST TOPIC ENDPOINTS

  test "an API user should be able to return a specific topic and its thread by ID" do
    topic = Topic.find(4)

    get "/api/v1/topics/#{topic.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == topic.id
    assert object['name'] == topic.name
    assert object['posts'].count == topic.posts.count
    assert_equal 'ticket', object['kind']
  end

  test "an API user should be able to create a topic" do
    user = User.find(2)

    params = {
      name: "Got a problem",
      body: "This is some really profound question",
      user_id: user.id,
      forum_id: 3
    }

    post '/api/v1/topics.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal object['forum_id'], 3
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
    assert object['channel'] == 'api'
  end

  test "an API user should be able to update a public topic" do
    topic = Topic.find(4)

    params = {
      id: topic.id,
      forum_id: 3,
      current_status: 'open',
      private: false,
      assigned_user_id: 1
    }

    patch "/api/v1/topics/#{topic.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)
    assert object['forum_id'] == 3
  end

  # TEST topic splitting
  test "an API user should be able to split a topic" do
    post = Post.find(4)

    params = {
      post_id: post.id,
    }

    post "api/v1/tickets/split/#{post.id}.json", @default_params.merge(params)

    new_topic =  JSON.parse(last_response.body)
    new_topic_object = Topic.find(new_topic['id'])

    # Check new topic title correctly set.
    assert_equal new_topic['name'], I18n.t('new_discussion_topic_title', original_name: post.topic.name, original_id: post.topic.id)

    # Check that first post in new topic is same as post which it was split from
    assert_equal new_topic_object.posts.first.body, post.body

    # Check that a reply was left in old topic
    assert_equal post.topic.posts.last.body, I18n.t('new_discussion_post', topic_id: new_topic['id'])

    # Assert Forum is same
    assert_equal new_topic['forum_id'], post.topic.forum_id

    # Assert topic owner is post owner
    assert_equal new_topic['user_id'], post.user_id
  end

  # TEST MERGING TOPICS
  test "an API user should be able to merge tickets" do

    # Build some topics to merge
    topica = Topic.create(name: "message A", user_id: 1, forum_id: 1, private: true)
    topica.posts.create(kind: 'first', body: 'message A first', user_id: 1)
    topica.posts.create(kind: 'reply', body: 'message A reply', user_id: 1)
    topicb = Topic.create(name: "message B", user_id: 1, forum_id: 1, private: true)
    topicb.posts.create(kind: 'first', body: 'message B first', user_id: 1)
    topicb.posts.create(kind: 'reply', body: 'message B reply', user_id: 1)

    params = {
      topic_ids: [topica.id, topicb.id],
      user_id: 1
    }

    post '/api/v1/tickets/merge.json', @default_params.merge(params)
    object = JSON.parse(last_response.body)

    assert_equal('email', object['channel'])
    assert_equal(4, object['posts'].count, "Should be 4 posts")
    assert_equal("MERGED: Message A", object['name'], "New topic title is wrong")
    assert_equal("ticket", object['kind'], "New topic kind is wrong")
    assert_equal('note', object['posts'].last['kind'], "The last post should be a note")
  end

  test "attempting to split a non existent post 404s (Not Found)" do
    params = {
      post_id: 'breh',
    }

    post "api/v1/tickets/split/10000.json", @default_params.merge(params)

    assert_equal 404, last_response.status
  end
end
