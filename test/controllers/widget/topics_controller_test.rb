require 'test_helper'

class Widget::TopicsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a logged out user should be able to see the widget" do
    get :new
    assert_response :success

    assert_select "input#topic_user_email", 1
    assert_select "input#topic_user_name", 1
    assert_select "input#topic_name", 1
  end

  test "a signed in user should be able to see the widget" do
    sign_in users(:user)
    get :new
    assert_response :success

    assert_select "input#topic_user_email", 0
    assert_select "input#topic_user_name", 0
    assert_select "input#topic_name", 1
  end

  # A user who is signed in should be able to create a new private or public topic
  test 'a signed in user should be able to create a new private topic' do
    sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      post :create, topic: { name: 'some new private topic', body: 'some body text', forum_id: 1, private: true, posts_attributes: {:"0" => {body: "this is the body"}} }, locale: :en
    end
    assert_difference 'Post.count', 1, 'A post should have been created' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 1, private: true, posts_attributes: {:"0" => {body: "this is the body"}} }, locale: :en
    end

    assert_redirected_to widget_thanks_path, 'Did not redirect to thanks view'
  end


end
