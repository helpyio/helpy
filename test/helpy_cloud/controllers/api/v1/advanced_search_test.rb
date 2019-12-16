require 'test_helper'

class API::V1::AdvancedSearchTest < ActiveSupport::TestCase
  include Rack::Test::Methods

  def app
    Rails.application
  end

  setup do
    set_default_settings
    @user = users(:admin)
    @api_key = ApiKey.create(name: "Test Search Key", user: @user)
    @default_params = { token: @api_key.access_token }
  end

  test "an unauthenticated user should receive an unauthorized message" do
    post "/api/v1/advanced_search/tickets"

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "adva should require a query parameter" do
    post "/api/v1/advanced_search/tickets", @default_params

    # Check 400 response
    assert_equal 400, last_response.status
  end

  # TODO Get these tests written correctly so they pass
  # test "searching for a ticket should return results" do
  #   params = {
  #     "id_eq": Topic.first.id
  #   }
  #
  #   query = "{'id_eq': #{Topic.first.id}}"
  #   post "/api/v1/advanced_search/tickets/", @default_params.merge(q: query)
  #
  #   # Check OK
  #   assert last_response.ok?, "Response was #{last_response.status}, expected 200"
  #
  #   # Check returned value
  #   objects = JSON.parse(last_response.body)
  #   assert_equal 1, objects['results'].count
  # end
  #
  # test "searching for a user should return results" do
  #   params = {
  #     "name_cont": User.first.name
  #   }
  #   post "/api/v1/advanced_search/users/", @default_params.merge(q: params)
  #
  #   # Check OK
  #   assert last_response.ok?, "Response was #{last_response.status}, expected 200"
  #
  #   # Check returned value
  #   objects = JSON.parse(last_response.body)
  #   assert_equal 1, objects['results'].count
  # end


end
