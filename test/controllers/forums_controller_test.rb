require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
    assert_equal(1, assigns(:forums).count)
  end

  # logged out, should not get these pages

  test "should not get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should not get edit" do
    get :edit
    assert_redirected_to new_user_session_path
  end

  test "should not get create" do
    post :create
    assert_redirected_to new_user_session_path
  end

  test "should not get update" do
    patch :update
    assert_redirected_to new_user_session_path
  end

  test "should not get destroy" do
    delete :destroy
    assert_redirected_to new_user_session_path
  end

  #logged in, should get these pages

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, forum_id: 3
    assert_response :success
  end

  test "should get create" do
    sign_in users(:admin)
    post :create
    assert_response :success
  end

  test "should get update" do
    sign_in users(:admin)
    patch :update, forum_id: 3
    assert_response :success
  end

  test "should get destroy" do
    sign_in users(:admin)
    delete :destroy
    assert_response :success
  end

end
