require 'test_helper'

class ForumsControllerTest < ActionController::TestCase

  test "a browser should get index" do
    get :index
    assert_response :success
    assert_equal(1, assigns(:forums).count)
  end

  # logged out, should not get these pages

  test "a browser should not get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "a browser should not get edit" do
    get :edit, { id: 3 }
    assert_redirected_to new_user_session_path
  end

  test "a browser should not get create" do
    post :create, forum: {name: "some name", description: "some descrpition"}
    assert_redirected_to new_user_session_path
  end

  test "a browser should not get update" do
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"} }
    assert_redirected_to new_user_session_path
  end

  test "a browser should not get destroy" do
    delete :destroy, { id: 3 }
    assert_redirected_to new_user_session_path
  end

  # logged in as user, should not get these pages

  test "a user should not get new" do
    sign_in users(:user)
    get :new
    assert_redirected_to root_path
  end

  test "a user should not get edit" do
    sign_in users(:user)
    get :edit, { id: 3 }
    assert_redirected_to root_path
  end

  test "a user should not get create" do
    sign_in users(:user)
    post :create, forum: {name: "some name", description: "some descrpition"}
    assert_redirected_to root_path
  end

  test "a user should not get update" do
    sign_in users(:user)
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"} }
    assert_redirected_to root_path
  end

  test "a user should not get destroy" do
    sign_in users(:user)
    delete :destroy, { id: 3 }
    assert_redirected_to root_path
  end



  #logged in as admin, should get these pages

  test "an admin should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "an admin should get edit" do
    sign_in users(:admin)
    get :edit, id: 3
    assert_response :success
  end

  test "an admin should get create" do
    sign_in users(:admin)
    post :create, forum: {name: "some name", description: "some descrpition"}
    assert_redirected_to admin_communities_path
  end

  test "an admin should get update" do
    sign_in users(:admin)
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"} }
    assert_redirected_to admin_communities_path
  end

  test "an admin should get destroy" do
    sign_in users(:admin)
    delete :destroy, id: 3
    assert_redirected_to admin_communities_path
  end

end
