# == Schema Information
#
# Table name: forums
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  topics_count       :integer          default(0), not null
#  last_post_date     :datetime
#  last_post_id       :integer
#  private            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  allow_topic_voting :boolean          default(FALSE)
#  allow_post_voting  :boolean          default(FALSE)
#  layout             :string           default("table")
#

require 'test_helper'

class API::V1::ForumsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Forums Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    get '/api/v1/forums.json'

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return forums" do
    get '/api/v1/forums.json', @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == Forum.count, "Only #{objects.length} returned out of #{Forum.count} forums"
  end

  test "an API user should be able to return a specific forum" do
    forum = Forum.find(3)
    get "/api/v1/forums/#{forum.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == forum.id
    assert object['name'] == forum.name
  end

  test "an API user should be able to create a forum" do
    params = {
      name: Faker::Company.catch_phrase,
      description: Faker::Lorem.paragraph
    }

    post '/api/v1/forums.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
  end

  test "an API user should not be able to create an invalid forum" do
    params = {
      name: nil,
      description: Faker::Lorem.paragraph
    }

    post '/api/v1/forums.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a forum" do
    forum = Forum.find(3)
    params = {
      name: "Updated forum name",
      description: Faker::Lorem.paragraph
    }

    patch "/api/v1/forums/#{forum.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal "Updated forum name", object['name']
  end
end
