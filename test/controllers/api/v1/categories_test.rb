# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class API::V1::CategoriesTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Categories Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    get '/api/v1/categories.json'

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return categories" do
    get '/api/v1/categories.json', @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    objects = JSON.parse(last_response.body)
    assert objects.length == Category.active.publicly.count, "Only #{objects.length} returned out of #{Category.active.count} categories"
  end

  test "an API user should be able to return a specific category" do
    category = Category.first
    get "/api/v1/categories/#{category.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == category.id
    assert object['name'] == category.name
  end

  test "an API user should not be able to return inactive categories" do
    category = Category.find_by(active: false)
    get "/api/v1/categories/#{category.id}.json", @default_params

    # Check not found
    assert_equal 404, last_response.status
  end

  test "an API user should not be able to return internal categories" do
    category = Category.find_by(active: true, visibility: 'internal')
    get "/api/v1/categories/#{category.id}.json", @default_params

    # Check not found
    assert_equal 404, last_response.status
  end

  test "an API user should be able to create a category" do
    params = {
      name: Faker::Company.catch_phrase,
      icon: "clock",
      keywords: Faker::Lorem.words(number: 4).join(','),
      title_tag: Faker::Company.catch_phrase,
      meta_description: Faker::Lorem.paragraph,
      rank: Faker::Number.between(from: 1, to: 10),
      front_page: true,
      active: true
    }

    post '/api/v1/categories.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
  end

  test "an API user should not be able to create an invalid category" do
    params = {
      name: nil,
      icon: "clock",
      keywords: Faker::Lorem.words(number: 4).join(','),
      title_tag: Faker::Company.catch_phrase,
      meta_description: Faker::Lorem.paragraph,
      rank: Faker::Number.between(from: 1, to: 10),
      front_page: true,
      active: true
    }

    post '/api/v1/categories.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a category" do
    category = Category.first
    params = {
      name: Faker::Company.catch_phrase
    }

    patch "/api/v1/categories/#{category.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:name], object['name']
  end
end
