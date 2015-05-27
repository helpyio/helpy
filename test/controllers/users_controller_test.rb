require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  # browsers

  test "a browser should NOT be able to view edit profile page" do
    get :edit, id: 2
    assert_redirected_to new_user_session_path
  end


  # logged in users

  test "a signed in user should be able to edit their profile" do
    sign_in users(:user)
    get :edit, id: 2
    assert_not_nil(assigns(:user))
    assert_response :success
  end

  test "a signed in user should be able to update their profile" do
    sign_in users(:user)
    assert_difference('User.find(2).name.length') do
      patch :update, { id: 2, user: {name: 'something'} }
    end

    assert_response :success
  end

  test "a signed in user should NOT be able to change their admin or active status" do
    sign_in users(:user)
    patch :update, { id: 2, user: {admin: true} }
    assert users(:user).admin == false

    assert_response :success

  end

  # admins


  test "an admin should be able to update a user" do
    sign_in users(:admin)
    assert_difference('User.find(2).name.length') do
      xhr :patch, :update, { id: 2, user: {name: 'something'} }
    end

  end


end
