require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  test "a browsing user should get index of posts for a given topic, if its public" do
    get :index, topics(:public).id
    assert_response :success
  end

  # logged in user

  test "a signed in user should be able to reply to a topic" do
    sign_in users(:user)
    assert_difference 'Post.count', 1 do
      xhr :post, :create, topic_id: 1, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
    end
    assert :success
  end

  # logged in admin

  test "an admin should be able to reply to a topic" do
    sign_in users(:admin)
    assert_difference 'Post.count', 1 do
      xhr :post, :create, topic_id: 1, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
    end
    assert :success
  end


# Creating a note should not update the topic status
# making a note inactive should remove it from the post cache
# making a note active should add it to the post cache


=begin
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
=end

end
