# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  points     :integer          default(0)
#


require 'test_helper'

class API::V1::PostsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Posts Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    topic = Topic.find(2)

    params = {
      topic_id: topic.id,
      body: Faker::Lorem.paragraph,
      user_id: topic.user.id,
      kind: "reply"
    }
    post '/api/v1/posts.json', params

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to create a post for an existing topic" do
    topic = Topic.find(2)

    params = {
      topic_id: topic.id,
      body: Faker::Lorem.paragraph,
      user_id: topic.user.id,
      kind: "reply"
    }


    post '/api/v1/posts.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:body], object['body']
  end

  test "an API user should not be able to create an invalid post (without a topic)" do
    topic = Topic.find(2)

    params = {
      topic_id: nil,
      body: Faker::Lorem.paragraph,
      user_id: topic.user.id,
      kind: nil
    }

    post '/api/v1/posts.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a post" do
    post = Post.first
    params = {
      id: post.id,
      body: Faker::Lorem.paragraph,
      active: false
    }

    patch "/api/v1/posts/#{post.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:body], object['body']
    assert_equal params[:active], object['active']
  end
end
