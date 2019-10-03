# == Schema Information
#
# Table name: tags
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  color              :string
#

require 'test_helper'

class API::V1::TagsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Tags Key", user: @user)
    @default_params = { token: @api_key.access_token }

    @simple_tag = ActsAsTaggableOn::Tag.new(name: 'simple', description: nil, color: nil)
    @full_tag = ActsAsTaggableOn::Tag.new(name: 'full', description: 'description', color: '#336699')

    [@simple_tag, @full_tag].each do |tag|
      tag.save!
      ActsAsTaggableOn::Tagging.create!(tag_id: tag.id, taggable_type: 'Topic', context: 'tags')
    end
  end

  test "an unauthenticated user should receive an unauthorized message" do
    get '/api/v1/tags.json'

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return tags" do
    get '/api/v1/tags.json', @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == 2, "Only #{objects.length} returned out of 2 tags"
  end

  test "an API user should be able to return a specific tag" do
    get "/api/v1/tags/#{@simple_tag.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == @simple_tag.id
    assert object['name'] == @simple_tag.name
  end

  test "an API user should be able to create a tag" do
    params = {
      name: Faker::Company.catch_phrase,
      description: Faker::Lorem.paragraph,
      color: Faker::Color.hex_color
    }

    post '/api/v1/tags.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
  end

  test "an API user should not be able to create an invalid tag" do
    params = {
      name: nil,
      description: Faker::Lorem.paragraph
    }

    post '/api/v1/tags.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a tag" do
    params = {
      name: "Not simple anymore",
      description: Faker::Lorem.paragraph,
      color: "#ffcc99"
    }

    patch "/api/v1/tags/#{@simple_tag.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal "Not simple anymore", object['name']
  end
end
