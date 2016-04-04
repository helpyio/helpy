require 'integration_test_helper'
include Warden::Test::Helpers


class SignInFlowTest < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    I18n.available_locales = [:en, :es, :de, :fr, :et, :ca, :ru, :ja, 'zh-cn', 'zh-tw', 'pt', :nl]
    I18n.locale = :en
  end

  teardown do
    sign_out
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test "a browser should be able to sign in and be shown the home page" do
    sign_in
    assert_equal '/en', current_path
  end

  test "an admin should be able to sign in and be shown the admin page" do
    sign_in_admin
    assert_equal '/admin', path
  end

  # TODO: for some reason I could not get the admin login with the regular sign_in method to work
  # The current path never changed from /en so I had to resort to doing it this way:
  def sign_in_admin
    get "/en/users/sign_in"
    post '/en/users/sign_in', 'user[email]' => 'admin@test.com', 'user[password]' => '12345678'
    follow_redirect!
  end

end
