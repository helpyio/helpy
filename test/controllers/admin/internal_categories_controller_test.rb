require_relative '../../test_helper'

class Admin::InternalCategoriesControllerTest < ActionController::TestCase
  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test "listing internal categories" do
    get :index
    refute_nil assigns(:categories)
    assert_equal 5, assigns(:categories).length
    assert_response :success
  end

  test "showing inactive category" do
    get :show, id: 3
    assert_nil assigns(:category)
    assert_response :redirect
  end

  test "showing system category" do
    get :show, id: 5
    assert_nil assigns(:category)
    assert_response :redirect
  end

  test "showing active category" do
    get :show, id: 1
    refute_nil assigns(:category)
    assert_equal "active and featured", assigns(:page_title)
    assert_response :success
  end

  test "showing active internal category" do
    get :show, id: 6
    refute_nil assigns(:category)
    assert_equal "internal title", assigns(:page_title)
    assert_response :success
  end
end
