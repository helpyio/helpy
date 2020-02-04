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
#  doc_id           :integer          default(0)
#  channel          :string           default("email")
#  kind             :string           default("ticket")
#  priority         :integer          default(1)
#

require 'test_helper'

class TopicsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  teardown do
    AppSettings['settings.extension_whitelist'] = ""
    AppSettings['settings.extension_blacklist'] = ""
  end

  test 'a browsing user should get index of topics in a public forum' do
    get :index, forum_id: 3, locale: :en
    assert_not_nil assigns(:topics)
    assert_response :success, 'Should see a list of topic in the forum'
  end

  test "a browsing user should not index of topics if forums are not enabled" do
    AppSettings['settings.forums'] = "0"
      get :index, forum_id: 3, locale: :en
      assert_response :redirect 
      assert_equal(response.redirect_url, root_url)
  end

  test 'a browsing user should not get index of topics in a private forum' do
    get :index, forum_id: 1, locale: :en
    assert_nil assigns(:topics)
    assert_redirected_to root_path
  end

  test 'a browsing user should be able to view a ticket if anonymous access turned on' do
    AppSettings['settings.anonymous_access'] = '1'
    get :show, id: Topic.last.hashid, locale: :en
    assert_response :success
  end

  test 'browsing users should NOT be able to view a ticket if anonymous access is disabled' do
    AppSettings['settings.anonymous_access'] = '0'
    get :show, id: Topic.last.hashid, locale: :en
    assert_redirected_to root_path
  end

  test 'a browsing user should get the new topic page' do
    get :new, locale: :en
    assert_nil assigns(:topics)
    assert_response :success, 'Did not get the new topic page'
  end

  test 'the new topic should be set to private if enabled' do
    AppSettings['settings.default_private'] = '1'
    get :new, locale: :en
    assert_equal true, assigns(:topic).private
    assert_response :success, 'Did not get the new topic page'
  end

  test 'a browsing user should be able to create a new public topic without signing in' do
    get :new, locale: :en
    assert_response :success

    assert_difference 'User.count', 1, 'A user should be created' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end
    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end
    assert_difference 'Post.count', 1, 'The new topic should have had a post' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end

    assert_redirected_to topic_posts_path(assigns(:topic)), 'Did not redirect to new public topic'
  end

  test 'a browsing user should be able to sign up and post a new message at the same time, and receive an email' do

    assert_difference 'Topic.count', 1 do
      assert_difference 'ActionMailer::Base.deliveries.size', 2 do
        post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
      end
    end

  end

  test "a browsing user creating feedback on an article should be autotagged" do
    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create,
          topic: {
            user: {
              name: 'a user',
              email: 'anon@test.com'
              },
            name: 'some new feedback',
            body: 'some body text',
            forum_id: 1,
            doc_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
              body: "this is the body"
              }
            }
          },
          locale: :en
      end
    end

    assert_equal Topic.tagged_with("active and featured").count, 1
    assert_equal Topic.tagged_with("Feedback").count, 1
  end

  test 'a browsing user should not be able to vote' do
    assert_difference 'Topic.find(5).points', 0 do
      get :index, forum_id: 3, locale: :en
      xhr :post, :up_vote, { id: 5, locale: :en }
    end
  end

  test 'Helpy should capture the users locale when they create a new topic' do
    post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}} }, locale: :en
    assert_not_nil Topic.last.locale, 'Did not capture locale when user created new topic'
  end

  test 'a new topic created though the web form should have channel "web"' do
    post :create, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new public topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}} }, locale: :en
    assert_equal "web", Topic.last.channel
  end

  test 'a user should see the option to attach files if cloudinary configured' do

    # Make sure cloudinary cloud name is setup
    AppSettings['cloudinary.enabled'] = "1"
    AppSettings['cloudinary.cloud_name'] = "test-cloud"
    AppSettings['cloudinary.api_key'] = "some-key"
    AppSettings['cloudinary.api_secret'] = "test-cloud"

    # Get new topics page
    get :new, locale: :en
    assert_response :success

    assert_select("input#topic_screenshots", true)

  end

  test 'a user should not see the option to attach files if cloudinary is not configured' do

    # Make sure cloudinary cloud name is setup
    AppSettings['cloudinary.cloud_name'] = ""
    AppSettings['cloudinary.api_key'] = ""
    AppSettings['cloudinary.api_secret'] = ""

    # Get new topics page
    get :new, locale: :en
    assert_response :success

    assert_select("input#topic_screenshots", false)

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

    assert_redirected_to topic_thanks_path, 'Did not redirect to thanks view'
  end

  # A user who is signed in should be able to create a new private or public topic and attach a file
  test 'a signed in user should be able to create a new private topic and attach a file' do
    sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create,
          topic: {
            user: {
              name: 'a user',
              email: 'anon@test.com'
              },
            name: 'some new public topic',
            body: 'some body text',
            forum_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
              body: "this is the body",
              attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
              }
            }
          },
          locale: :en
      end
    end

    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
    assert_redirected_to topic_thanks_path, 'Did not redirect to thanks view'
  end

  # A new user who is NOT signed in should be able to create a new private or public topic and attach a file
  test 'a new user should be able to create a new private topic and attach a valid file' do
    #sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create,
          topic: {
            user: {
              name: 'a new user',
              email: 'anon_new@test.com'
              },
            name: 'some new topic',
            body: 'some body text',
            forum_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
              body: "this is the body",
              attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
              }
            }
          },
          locale: :en
      end
    end

    assert_equal "logo.png", Post.last.attachments.first.file.file.split("/").last
    assert_redirected_to topic_thanks_path, 'Did not redirect to thanks view'
  end

  # A new user who is NOT signed in should be able to create a new private or public topic and attach a file
  test 'a new user should NOT be able to create a new private topic with an invalid file' do
    #sign_in users(:user)
    AppSettings['settings.extension_whitelist'] = "txt,doc,docx,pdf"

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 0, 'A topic should NOT have been created' do
      assert_difference 'Post.count', 0, 'A post should NOT have been created' do
        post :create,
          topic: {
            user: {
              name: 'a new user',
              email: 'anon_new@test.com'
              },
            name: 'some new topic',
            body: 'some body text',
            forum_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
              body: "this is the body",
              attachments: Array.wrap(uploaded_file_object(Post, :attachments, file))
              }
            }
          },
          locale: :en
      end
    end

    assert_response :success
  end


  # A user who is registered, but not signed in currently should be able to create a new private
  # or public topic
  test 'an unsigned in user with an account should be able to create a new private topic' do

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      assert_difference 'Post.count', 1, 'A post should have been created' do
        post :create, topic: { user: { name: 'Scott Miller', email: 'scott.miller@test.com' }, name: 'some new private topic', body: 'some body text', forum_id: 1, private: true, posts_attributes: {:"0" => { body: "this is the body" } } }, locale: :en
      end
    end

    assert_redirected_to topic_thanks_path, 'Did not redirect to thanks view'
  end

  test 'a signed in user should not see trashed topics in a public forum' do
    sign_in users(:user)

  end

  test 'a signed in user should not see trashed tickets in tickets list ' do
    sign_in users(:user)

  end

  test 'a signed in user should not be able to display a trashed ticket' do
    sign_in users(:user)

  end

  test 'a signed in user should be able to vote' do
    sign_in users(:user)
    assert_difference 'Topic.find(5).points', 1 do
      get :index, forum_id: 3, locale: :en
      xhr :post, :up_vote, { id: 5 , locale: :en }
    end
  end

  test 'a browsing user should not be able to create a new public topic when they fall for the honeypot' do
    get :new, locale: :en
    assert_response :success

    assert_difference 'User.count', 0, 'No user should have been created' do
      assert_difference 'Topic.count', 0, 'No topic should have been created' do
        assert_difference 'Post.count', 0, 'No new post should have been created' do
          post :create, topic: { user: { name: 'a user', email: 'anon@test.com', private: false }, name: 'some new private topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}, url: 'http://spamy.spam'}, locale: :en
        end
      end
    end

    assert_response :success
    assert_select "#new_topic"
  end

  test 'a browsing user should be able to create a new public topic without signing in when recaptcha enable' do

    # Make sure recaptcha site_key is set
    AppSettings['settings.recaptcha_site_key'] = "some-key"
    AppSettings['settings.recaptcha_api_key'] = "some-key"

    #TopicsController.expects(:verify_recaptcha).returns(true)

    # Get new topics page
    get :new, locale: :en
    assert_response :success

    assert_difference 'User.count', 1, 'A user should be created' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com', private: false }, name: 'some new private topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end
    assert_difference 'Topic.count', 1, 'A topic should have been created' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com', private: false }, name: 'some new private topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end
    assert_difference 'Post.count', 1, 'The new topic should have had a post' do
      post :create, topic: { user: { name: 'a user', email: 'anon@test.com', private: false }, name: 'some new private topic', body: 'some body text', forum_id: 3, posts_attributes: {:"0" => {body: "this is the body"}}}, locale: :en
    end

    assert_redirected_to topic_posts_path(assigns(:topic)), 'Did not redirect to new private topic'

  end

  # test "a signed in user should not be able to create a new private ticket if tickets are not enabled" do
  #   AppSettings['settings.tickets'] = "0"
  #
  #   sign_in users(:user)
  #
  #   get :new, locale: :en
  #   assert_response :success
  #
  #   assert_difference 'Topic.count', 0, "A topic should not have been created" do
  #     post :create, topic: {name: "some new private topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}, locale: :en
  #   end
  #   assert_difference 'Post.count', 0, "A post should not have been created" do
  #     post :create, topic: { user: {name: 'a user', email: 'anon@test.com'}, name: "some new public topic", body: "some body text", forum_id: 1, private: true}, post: {body: 'this is the body'}, locale: :en
  #   end
  #
  #   assert_redirected_to ticket_path(assigns(:topic)), "Did not redirect to private topic view"
  # end

  test "a signed in user should be able to create a new private ticket if tickets are enabled" do
    AppSettings['settings.tickets'] = "1"

    sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      assert_difference 'Post.count', 1, "A post should have been created" do

        # TODO: refactor this into a method and DRY up tests

        post :create,
          topic: {
            user: {
              name: 'a user',
              email: 'anon@test.com'
            },
            name: "some new public topic",
            body: "some body text",
            forum_id: 1,
            private: true,
            posts_attributes: {
              :"0" => {
                body: "this is the body"
              }
            }
          },
          locale: :en
      end
    end

    assert_redirected_to topic_thanks_path, "Did not redirect to thanks view"
  end

  test "a signed in user should be able to create a new public discussion if forums are enabled" do
    AppSettings['settings.forums'] = "1"

    sign_in users(:user)

    get :new, locale: :en
    assert_response :success

    assert_difference 'Topic.count', 1, "A topic should have been created" do
      assert_difference 'Post.count', 1, "A post should have been created" do
        post :create,
          topic: {
            user: {
              name: 'a user',
              email: 'anon@test.com'
            },
            name: "some new public topic",
            body: "some body text",
            forum_id: 4,
            private: false,
            posts_attributes: {
              :"0" => {
                body: "this is the body"
              }
            }
          },
          locale: :en
      end
    end


    assert_redirected_to topic_posts_path(Topic.last), "Did not redirect to forum topic view"
  end

  test "a signed in user should not be able to create a new private or public topic if tickets and forums are not enabled" do
    AppSettings['settings.tickets'] = "0"
    AppSettings['settings.forums'] = "0"

    sign_in users(:user)
      get :new, locale: :en
      assert_response :redirect 
      assert_equal(response.redirect_url, root_url)
  end

end
