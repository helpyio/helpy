require 'test_helper'

class WidgetControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a logged out user should be able to see the widget" do
    get :index
    assert_response :success

    assert_select "input#topic_user_email", 1
    assert_select "input#topic_user_name", 1
    assert_select "input#topic_name", 1
  end

  test "a signed in user should be able to see the widget" do
    sign_in users(:user)
    get :index
    assert_response :success

    assert_select "input#topic_user_email", 0
    assert_select "input#topic_user_name", 0
    assert_select "input#topic_name", 1
  end

end
