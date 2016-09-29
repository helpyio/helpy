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
      user_id: user.id
    }

    post '/api/v1/tickets.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal 1, object['forum_id']
    assert object['name'] == "Got a problem"
    assert object['posts'].count == 1
    assert object['posts'][0]['body'] == "This is some really profound question"
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



end
