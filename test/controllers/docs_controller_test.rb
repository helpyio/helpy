require 'test_helper'

class DocsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get edit" do
    get :edit
    assert_response :success
  end

  test "should get create" do
    get :create
    assert_response :success
  end

  test "should get update" do
    get :update
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

  test "should get set_docs" do
    get :set_docs
    assert_response :success
  end

  test "should get home" do
    get :home
    assert_response :success
  end

  test "should get get_tags" do
    get :get_tags
    assert_response :success
  end

  test "should get view_causes_vote" do
    get :view_causes_vote
    assert_response :success
  end

end
