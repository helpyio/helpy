# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  topic_id    :integer
#  user_id     :integer
#  body        :text
#  kind        :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  points      :integer          default(0)
#  attachments :string           default([]), is an Array
#  cc          :string
#  bcc         :string
#  raw_email   :text
#

require 'test_helper'

class PostsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  # browsers (anonymous users)

  test "a browsing user should get index of posts for a given topic, if its public" do
    get :index, topic_id: topics(:public).id, locale: :en
    assert_response :success
  end

  test "a browsing user should NOT get index of posts for a given topic, if its private" do
    get :index, topic_id: topics(:pending).id, locale: :en
    assert_redirected_to root_path
  end

  test "a browsing user should not be able to see inactive posts" do
    post = posts(:inactive_reply)
    get :index, topic_id: topics(:public).id, locale: :en
    refute assigns(:posts).include? post.id
  end

  test "a browsing user should not be able to vote" do
    assert_difference "Post.find(6).points", 0 do
      get :index, forum_id: 3, locale: :en
      xhr :post, :up_vote, { id: 6, locale: :en }
    end
  end

  test "a browsing user should not get index of posts for a given topic, if forums are disabled" do
    AppSettings['settings.forums'] = "0"
      get :index, topic_id: topics(:public).id, locale: :en
      assert_response :redirect 
      assert_equal(response.redirect_url, root_url)
  end

  # logged in user

  test "a signed in user should see one reply form" do
    sign_in users(:user)

    # Loop through several test cases for different types of topic layout/voteability etc.
    # The Q&A format uses an inline reply form immediately beneath the original question
    [4,5,7,8].each do |topic_id|
      get :index, topic_id: topic_id, locale: :en
      assert_select "div.add-form", true, "failed on #{topic_id}"
      assert :success
    end
  end

  test "a signed in user should be able to reply to a topic" do
    sign_in users(:user)
    assert_difference "Post.count", 1 do
      xhr :post, :create, topic_id: 1, locale: :en , post: { user_id: User.find(2).id, body: "new reply", kind: "reply" }
    end
    assert :success
  end

  test "a signed in user should be able to post a reply to an open topic and the topic status should change to pending" do
    sign_in users(:user)
    assert_difference "Topic.where(current_status: 'pending').count", 1 do
      xhr :post, :create, topic_id: 1, locale: :en, post: { user_id: User.find(2).id, body: "new reply", kind: "reply" }
    end
  end

  test "a signed in user should be able to vote" do
    sign_in users(:user)
    assert_difference "Post.find(6).points", 1 do
      xhr :post, :up_vote, id: 6, topic_id: 5, locale: :en
    end
  end

  test "a signed in user should be able to add an attachment" do
    sign_in users(:user)
    assert_difference "Post.count", 1 do
      post :create,
        topic_id: 1,
        locale: :en,
        post: {
          user_id: User.find(2).id,
          body: "new reply",
          kind: "reply",
          attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
        }
    end
    # binding.pry
    assert :success
    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
  end
end
