require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  test "a browsing user should get index of topics in a public forum" do
    get :index, forum_id: 3
    assert_not_nil assigns(:topics)
    assert_response :success, "Should see a list of topic in the forum"
  end

  test "a browsing user should not get index of topics in a private forum" do
    get :index, forum_id: 1
    assert assigns(:topics).count == 0, "Topics should be zero"
    assert_response :success
  end

  test "a browsing user should get the new topic page" do
    get :new
    assert_nil assigns(:topics)
    assert_response :success, "Did not get the new topic page"
  end

  test "a browsing user should be able to create a new public topic without signing in" do
    get :new
    assert_response :success

    assert_difference 'User.count', 1, "A user should be created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}
    end
    assert_difference 'Topic.count', 1, "A topic should have been created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}
    end
    assert_difference 'Post.count', 1, "The new topic should have had a post" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}
    end

    # TODO: assert email sent to user

    assert_redirected_to topic_posts_path(assigns(:topic)), "Did not redirect to new public topic"
  end

  test "a signed in user should be able to create a new private topic" do
    sign_in users(:user)

    get :new
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      post :create, topic: {name: "some new private topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}
    end
    assert_difference 'Post.count', 1, "A post should have been created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}
    end

    assert_redirected_to ticket_path(assigns(:topic)), "Did not redirect to private topic view"
  end


  test "a signed in user should not see trashed topics in a public forum" do
    sign_in users(:user)

  end

  test "a signed in user should not see trashed tickets in tickets list " do
    sign_in users(:user)

  end

  test "a signed in user should not be able to display a trashed ticket" do
    sign_in users(:user)

  end


=begin
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
=end

  #test "new private ticket should appear in search" do
  #end

  #test "new private ticket should" do
  #end

  #

end
