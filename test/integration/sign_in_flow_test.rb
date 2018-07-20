require 'integration_test_helper'
include Warden::Test::Helpers

class SignInFlowTest < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    set_default_settings
    OmniAuth.config.test_mode = true
  end

  teardown do
    OmniAuth.config.test_mode = false
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  def sign_out
    visit '/'
    within("div#above-header") do
      click_on("Logout")
    end
  end

  test "a browser should be able to sign in and be shown the home page" do
    sign_in
    assert_equal '/en', current_path
    sign_out
  end

  test "an admin should be able to sign in and be shown the topics page" do
    sign_in("admin@test.com")
    assert_equal '/admin/topics', current_path
    sign_out
  end

  test "an agent should be able to sign in and be shown the topics page" do
    sign_in("agent@test.com")
    assert_equal '/admin/topics', current_path
    sign_out
  end

  test "an editor should be able to sign in and be shown the categories page" do
    sign_in("editor@test.com")
    assert_equal '/en', current_path
    sign_out
  end

  test "a browser visiting an admin page should be redirected to login in their locale" do
    visit '/admin'
    assert_equal '/en/users/sign_in', current_path
  end

  test "a user should not be able to login if he is inactive" do
    sign_in("user_inactive@test.com")
    assert_equal '/en/users/sign_in', current_path
  end

  test "all omniauth providers are registered" do
    assert_equal(Devise.omniauth_providers.count, Settings['omniauth']['providers'].count)
  end

  Devise.omniauth_providers.each do |provider|
    test "#{provider} login: is redirected to provider" do
      get user_omniauth_authorize_path(provider)
      assert_response :redirect
    end

    test "#{provider} login: full user is redirect to index" do
      @auth_hash = {:uid => '12345', :info => {:name => "A #{provider} user", :email => 'joe@example.com'}}
      OmniAuth.config.add_mock(provider, @auth_hash)

      post user_omniauth_callback_path(provider)
      assert_redirected_to root_path
    end

    test "#{provider} login: login with no email is redirected to finish_signup" do
      @auth_hash = {:uid => '12345', :info => {:name => "A #{provider} email-less user"}}
      OmniAuth.config.add_mock(provider, @auth_hash)

      post user_omniauth_callback_path(provider)
      assert_redirected_to finish_signup_path
    end
  end

  test "Unknown provider leads to 404" do
    assert_raise ActionController::UrlGenerationError do
      get user_omniauth_authorize_path("unknown")
    end

    assert_raise ActionController::UrlGenerationError do
      post user_omniauth_callback_path("unknown")
    end
  end

end
