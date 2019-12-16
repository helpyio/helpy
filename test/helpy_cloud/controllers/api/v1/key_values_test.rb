require 'test_helper'

class API::V1::KeyValuesTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test KV Key", user: @user)
    @default_params = { token: @api_key.access_token }

    KeyValue.create(
      kvable_id: Topic.first.id,
      kvable_type: 'Topic',
      key: 'test',
      value: 'it'
    )
  end

  test "an unauthenticated user should receive an unauthorized message" do
    kv = KeyValue.first
    get "/api/v1/key_values/#{kv.id}.json"

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to return a specific key_value" do
    key_value = KeyValue.first
    get "/api/v1/key_values/#{key_value.id}.json", @default_params

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body)
    assert object['key'] == key_value.key
    assert object['value'] == key_value.value
  end

  test "an API user should be able to return key values for an object" do
    key_value = KeyValue.first
    params = {
      kvable_id: Topic.first.id,
      kvable_type: 'Topic'
    }
    get "/api/v1/key_values.json", @default_params.merge(params)

    # Check OK
    assert last_response.ok?, "Response was #{last_response.status}, expected 200"

    # Check returned value
    object = JSON.parse(last_response.body).first
    assert object['key'] == key_value.key
    assert object['value'] == key_value.value
  end

  test "an API user should be able to create a key_value" do
    params = {
      kvable_id: Topic.second.id,
      kvable_type: 'Topic',
      key: 'test',
      value: 'two'
    }

    post '/api/v1/key_values.json', @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:key], object['key']
  end


  test "an API user should be able to update a key_value" do
    key_value = KeyValue.first
    params = {
      id: key_value.id,
      kvable_id: Topic.first.id,
      kvable_type: 'Topic',
      key: 'update',
      value: 'test'
    }

    patch "/api/v1/key_values/#{key_value.id}.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)

    assert_equal params[:key], object['key']
    assert_equal params[:value], object['value']
  end

  test "should be able to update multiple values a json object" do
    key_value = KeyValue.first
    params = {
      kvable_id: Topic.first.id,
      kvable_type: 'Topic',
      json: '{"test":"tested"}'
    }

    patch "/api/v1/key_values.json", @default_params.merge(params)

    object = JSON.parse(last_response.body)[0]
    assert_equal "test", object['key']
    assert_equal "tested", object['value']
  end

  test "an API user should be able to delete a key_value" do
    key_value = KeyValue.first
    delete "/api/v1/key_values/#{key_value.id}.json", @default_params
    # object = JSON.parse(last_response.body)
    assert_equal last_response.body, ""
  end
end
