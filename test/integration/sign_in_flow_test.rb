require 'test_helper'
include Warden::Test::Helpers

class SignInFlowTest < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  test "a browser should be able to sign in and be shown the home page" do
    get "/en/users/sign_in"
    # user = assigns(:user)
    post '/en/users/sign_in', 'user[email]' => 'scott.miller@test.com', 'user[password]' => '12345678'
    follow_redirect!
    assert_equal '/en', path
  end

  test "an admin should be able to sign in and be shown the admin page" do
    get "/en/users/sign_in"
    # user = assigns(:user)
    post '/en/users/sign_in', 'user[email]' => 'admin@test.com', 'user[password]' => '12345678'
    follow_redirect!
    assert_equal '/admin', path
  end

end
