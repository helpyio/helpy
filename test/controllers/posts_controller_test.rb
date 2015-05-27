require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  # browsers (anonymous users)

  test "a browsing user should get index of posts for a given topic, if its public" do
    get :index, topic_id: topics(:public).id
    assert_response :success
  end

  test "a browsing user should NOT get index of posts for a given topic, if its private" do
    get :index, topic_id: topics(:pending).id
    assert_redirected_to root_path
  end

  test "a browsing user should not be able to see inactive posts" do
    post = posts(:inactive_reply)
    get :index, topic_id: topics(:public).id
    assert (not assigns(:posts).include? post.id)
  end

  # logged in user

  test "a signed in user should be able to reply to a topic" do
    sign_in users(:user)
    assert_difference 'Post.count', 1 do
      xhr :post, :create, topic_id: 1, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
    end
    assert :success
  end

  test "a signed in user should NOT be able to edit a post" do
    sign_in users(:user)
    original_post = Post.find(1)
    xhr :patch, :update, { id: 1, post: { body: 'this has changed' }}
    assert original_post.body == Post.find(1).body
    assert :success
  end

  test "when a signed in user posts a reply, the topic status should not change" do
    sign_in users(:user)
    @topic = Topic.find(1)
    assert_no_difference 'Topic.where(current_status: @topic.current_status).count' do
      xhr :post, :create, topic_id: 1, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
    end
  end

  # logged in admin

  # TODO this belongs in the admin controller test where all admin logic resides
  test "an admin should be able to see inactive posts" do

  end


  test "an admin should be able to reply to a private topic, and the system should send an email" do
    sign_in users(:admin)

    assert_difference 'MandrillMailer.deliveries.size', 1 do
      assert_difference 'Post.count', 1 do
        xhr :post, :create, topic_id: 1, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
      end
    end
    assert :success
  end

  test "an admin should be able to reply to a public topic, and the system should NOT send an email" do
    sign_in users(:admin)

    assert_difference 'MandrillMailer.deliveries.size', 0 do
      assert_difference 'Post.count', 1 do
        xhr :post, :create, topic_id: 4, post: { user_id: User.find(2).id, body: 'new reply', kind: 'reply' }
      end
    end
    assert :success
  end


  test "an admin should be able to edit a post" do
    sign_in users(:admin)
    old = Post.find(1).body
    xhr :patch, :update, {id: 1, post: { body: 'this has changed' }  }
    assert old != Post.find(1).body
    assert :success
  end


end
