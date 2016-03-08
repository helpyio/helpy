# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#

require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  setup do
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  test "a browsing user should get index of topics in a public forum" do
    get :index, forum_id: 3, locale: :en
    assert_not_nil assigns(:topics)
    assert_response :success, "Should see a list of topic in the forum"
  end

  test "a browsing user should not get index of topics in a private forum" do
    get :index, forum_id: 1, locale: :en
    assert_nil assigns(:topics)
    assert_redirected_to root_path
  end

  test "a browsing user should get the new topic page" do
    get :new, locale: :en
    assert_nil assigns(:topics)
    assert_response :success, "Did not get the new topic page"
  end

  test "a browsing user should be able to create a new public topic without signing in" do
    get :new, locale: :en
    assert_response :success

    assert_difference 'User.count', 1, "A user should be created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}, locale: :en
    end
    assert_difference 'Topic.count', 1, "A topic should have been created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}, locale: :en
    end
    assert_difference 'Post.count', 1, "The new topic should have had a post" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}, locale: :en
    end

    assert_redirected_to topic_posts_path(assigns(:topic)), "Did not redirect to new public topic"
  end

  test "a browsing user should be able to sign up and post a new message at the same time, and receive an email" do

    assert_difference 'Topic.count', 1 do
      assert_difference 'ActionMailer::Base.deliveries.size', 1 do
        post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}, locale: :en
      end
    end

  end

  test "a browsing user should not be able to vote" do
    assert_difference 'Topic.find(5).points', 0 do
      get :index, forum_id: 3, locale: :en
      xhr :post, :up_vote, { id: 5, locale: :en }
    end
  end

  test "Helpy should capture the users locale when they create a new topic" do
    post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 3}, post: {body: 'this is the body'}, locale: :en
    assert_not_nil Topic.last.locale, "Did not capture locale when user created new topic"
  end

  # A user who is signed in should be able to create a new private or public topic
  test "a signed in user should be able to create a new private topic" do
    sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      post :create, topic: {name: "some new private topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}, locale: :en
    end
    assert_difference 'Post.count', 1, "A post should have been created" do
      post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}, locale: :en
    end

    assert_redirected_to ticket_path(assigns(:topic)), "Did not redirect to private topic view"
  end

  # A user who is registered, but not signed in currently should be able to create a new private
  # or public topic
  test "an unsigned in user with an account should be able to create a new private topic" do

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      assert_difference 'Post.count', 1, "A post should have been created" do
        post :create, topic: { user: {name: 'Scott Miller', email: 'scott.miller@test.com'}, name: "some new private topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}, locale: :en
      end
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

  test "a signed in user should be able to vote" do
    sign_in users(:user)
    assert_difference 'Topic.find(5).points', 1 do
      get :index, forum_id: 3, locale: :en
      xhr :post, :up_vote, { id: 5 , locale: :en}
    end
  end

end
