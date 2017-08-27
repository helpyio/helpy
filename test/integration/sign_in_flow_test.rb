require 'integration_test_helper'
include Warden::Test::Helpers

class SignInFlowTest < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    set_default_settings
  end

  teardown do
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

  test "a browser should be able to sign by modal in and be redirected to the last page requested" do
    visit '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments'
    sign_in_by_modal
    assert_equal '/en/knowledgebase/1-active-and-featured/docs/6-allows-comments', current_path
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

end
