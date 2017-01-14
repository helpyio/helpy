require 'test_helper'

class API::V1::FlagsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end
  
  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Flags Key", user: @user)
    @default_params = { token: @api_key.access_token }
    Rails::logger.debug "Interesting stuff"
  end

  test "an unauthenticated user should receive an unauthorized message" do
    post = Post.first

    params = {
      post_id: post.id,
      reason: Faker::Lorem.sentence
    }
    post '/api/v1/flags.json', params

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to flag a post for review" do
    post = Post.first

    params = {
      post_id: post.id,
      reason: Faker::Lorem.sentence
    }
    post '/api/v1/flags.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:reason], object['reason']
  end
 end