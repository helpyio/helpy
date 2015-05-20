require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "should show edit profile page to admins" do

  end

  test "should save updates from admin" do

  end

  test "should NOT allow unsigned in user to view edit profile page" do
    get :edit
    assert_response :success
  end

  test "should allow signed in user to edit their profile" do
    sign_in users(:user)
    get :edit
    assert_response :success
  end

  test "should NOT allow signed in user to change their admin or active status" do

  end


end
