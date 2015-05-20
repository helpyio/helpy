require 'test_helper'

class DocsControllerTest < ActionController::TestCase

  test "should get show" do
    get :show, id: 1
    assert_response :success
  end

  # logged out, should not get these pages

  test "should not get new" do
    get :new
    assert_redirected_to new_user_session_path
  end

  test "should not get edit" do
    get :edit, { id: 3 }
    assert_redirected_to new_user_session_path
  end

  test "should not get create" do
    post :create, doc: {title: "some name", body: "some body text", category_id: 1}
    assert_redirected_to new_user_session_path
  end

  test "should not get update" do
    patch :update, { id: 1, doc: {title: "some name", body: "some body text", category_id: 1} }
    assert_redirected_to new_user_session_path
  end

  test "should not get destroy" do
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
    post :create, doc: {title: "some name", body: "some body text", category_id: 1}
    assert_redirected_to root_path
  end

  test "a user should not get update" do
    sign_in users(:user)
    patch :update, { id: 1, doc: {title: "some name", body: "some body text", category_id: 1} }
    assert_redirected_to root_path
  end

  test "a user should not get destroy" do
    sign_in users(:user)
    delete :destroy, { id: 3 }
    assert_redirected_to root_path
  end


  #logged in as admin, should get these pages

  test "should get new" do
    sign_in users(:admin)
    get :new
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, id: 1, category_id: 1
    assert_response :success
  end

  test "should get create" do
    sign_in users(:admin)
    post :create, doc: {title: "some name", body: "some body text", category_id: 1}
    assert_redirected_to admin_knowledgebase_path
  end

  test "should get update" do
    sign_in users(:admin)
    patch :update, { id: 1, doc: {title: "some name", body: "some body text", category_id: 1} }
    assert_redirected_to admin_knowledgebase_path
  end

  test "should get destroy" do
    sign_in users(:admin)
    xhr :delete, :destroy, id: 1
    assert_response :success
  end


end
