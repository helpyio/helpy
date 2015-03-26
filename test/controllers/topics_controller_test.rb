require 'test_helper'

class TopicsControllerTest < ActionController::TestCase
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

  test "should get up_vote" do
    get :up_vote
    assert_response :success
  end

  test "should get down_vote" do
    get :down_vote
    assert_response :success
  end

  test "should get make_private" do
    get :make_private
    assert_response :success
  end

  test "should get tag" do
    get :tag
    assert_response :success
  end

  #test "new private ticket should appear in search" do
  #end

  #test "new private ticket should" do
  #end

end
