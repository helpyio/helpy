# == Schema Information
#
# Table name: docs
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  category_id      :integer
#  user_id          :integer
#  active           :boolean          default(TRUE)
#  rank             :integer
#  permalink        :string
#  version          :integer
#  front_page       :boolean          default(FALSE)
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)
#


require 'test_helper'

class API::V1::DocsTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Docs Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    doc = Doc.first
    get "/api/v1/docs/#{doc.id}.json"

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return a specific doc" do
    doc = Doc.first
    get "/api/v1/docs/#{doc.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['id'] == doc.id
    assert object['title'] == doc.title
  end

  test "an API user should not be able to return inactive docs" do
    doc = Doc.find_by(active: false)
    get "/api/v1/docs/#{doc.id}.json", @default_params

    # Check not found
    assert_equal 404, last_response.status
  end

  test "an API user should not be able to return internal docs" do
    doc = Doc.joins(:category).find_by(active: true, categories: { visibility: 'internal' })
    get "/api/v1/docs/#{doc.id}.json", @default_params

    # Check not found
    assert_equal 404, last_response.status
  end

  test "an API user should be able to create a doc" do
    params = {
      title: Faker::Company.catch_phrase,
      body: Faker::Lorem.paragraph,
      category_id: Category.first.id,
      user_id: User.first.id
    }

    post '/api/v1/docs.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:title], object['title']
  end

  test "an API user should not be able to create an invalid doc" do
    params = {
      title: nil,
      body: Faker::Lorem.paragraph,
      category_id: Category.first.id,
      user_id: User.first.id
    }

    post '/api/v1/docs.json', @default_params.merge(params)

    assert_equal 422, last_response.status
  end

  test "an API user should be able to update a doc" do
    doc = Doc.first
    params = {
      title: Faker::Company.catch_phrase,
      category_id: Category.first.id,
      front_page: false
    }

    patch "/api/v1/docs/#{doc.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:title], object['title']
    assert_equal params[:front_page], object['front_page']
  end
end
