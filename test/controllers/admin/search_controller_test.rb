require 'test_helper'

class Admin::SearchControllerTest < ActionController::TestCase

  setup do
    sign_in users(:admin)
  end

  test 'an admin should be able to search by topic ID by ajax' do
    xhr :get, :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test 'an admin should be able to search by user name by ajax' do
    xhr :get, :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test 'an admin should be able to search by subject by ajax' do
    xhr :get, :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test 'an admin should be able to search for users with multiple matches via ajax' do
    xhr :get, :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(3, assigns(:users).size)
    assert_response :success
  end

  test 'an admin should be able to search by topic ID' do
    get :topic_search, q: '1'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test 'an admin should be able to search by user name' do
    get :topic_search, q: 'Admin User'
    assert_not_nil assigns(:user)
    assert_response :success
  end

  test 'an admin should be able to search by subject' do
    get :topic_search, q: 'Pending private topic'
    assert_not_nil assigns(:topics)
    assert_response :success
  end

  test 'an admin should be able to search for users with multiple matches' do
    get :topic_search, q: 'scott'
    assert_nil assigns(:topics)
    assert_not_nil assigns(:users)
    assert_equal(3, assigns(:users).size)
    assert_response :success
  end

end
