require 'test_helper'

class SessionsControllerTest < ActionController::TestCase

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    set_default_settings
  end

  test "allows sign in of a active user" do
    post :create, user: { email: 'scott.smith@test.com', password: '12345678' }
    assert_redirected_to root_path
    assert_equal 'Signed in successfully.', flash[:notice]
  end

  test "denies sign in of a non-active user" do
    post :create, user: { email: 'not_active@test.com', password: '12345678' }
    assert_redirected_to root_path
    assert_equal "Your account is inactive.", flash[:alert]
  end
end
