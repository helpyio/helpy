require 'test_helper'

class API::V1::SettingsTest < ActiveSupport::TestCase
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
    get "/api/v1/settings.json"

    # Check not authorized
    assert_equal 401, last_response.status
  end

  test "an API user should be able to see a list of all settings" do
    get "/api/v1/settings.json", @default_params

    object = JSON.parse(last_response.body)
    assert_not_equal object.count, nil
  end

  test "an API user should be able to update a setting" do

    params = {
      key: 'settings.site_name',
      value: 'Settings Tested'
    }

    post "/api/v1/settings.json", @default_params.merge(params)

    #object = JSON.parse(last_response.body)

    assert_equal AppSettings['settings.site_name'], 'Settings Tested'
  end

end
