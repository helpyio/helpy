require 'integration_test_helper'

include Warden::Test::Helpers

class BrowsingUserTicketFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Capybara.current_driver = :chrome
    Warden.test_mode!
    logout(:user)
    set_default_settings
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
    Capybara.use_default_driver
  end

  test "a browsing user who is not registered should be able to create a private ticket via the web interface" do

    # make sure recaptcha is disabled
    AppSettings['settings.recaptcha_site_key'] = ""
    AppSettings['settings.recaptcha_api_key'] = ""

    # create new private ticket
    visit '/en/topics/new/'

    # a new user should be created
    assert_difference('User.count', 1) do
      assert_difference('Topic.count',1) do
        fill_in('topic_user_email', with: Faker::Internet.email)
        fill_in('topic[user][name]', with: Faker::Name.name)
        fill_in('topic[name]', with: 'I got problems')
        fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
        click_on('Create Ticket')
      end
    end
    assert current_path == '/en/thanks'

  end

  test "should NOT be able to create a private ticket if name/email missing" do

    # make sure recaptcha is disabled
    AppSettings['settings.recaptcha_site_key'] = ""
    AppSettings['settings.recaptcha_api_key'] = ""

    # create new private ticket
    visit '/en/topics/new/'

    # a new user should be created
    assert_difference('User.count', 0) do
      assert_difference('Topic.count',0) do
        fill_in('topic_user_email', with: '')
        fill_in('topic[user][name]', with: '')
        fill_in('topic[name]', with: 'I got problems')
        fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
        click_on('Create Ticket')
      end
    end
    assert page.has_content?("can't be blank")

  end

  test "a browsing user who is not registered should be able to create a public ticket via the web interface when recaptcha enable" do

    # make sure recaptcha is enabled
    AppSettings['settings.recaptcha_enabled'] = "1"
    AppSettings['settings.recaptcha_site_key'] = "some-key"
    AppSettings['settings.recaptcha_api_key'] = "some-key"

    # create new private ticket
    visit '/en/topics/new/'

    # a new user should be created
    # assert_difference('User.count', 1) do
      assert_difference('Topic.count',1) do
        fill_in('topic_user_email', with: Faker::Internet.email)
        fill_in('topic[user][name]', with: Faker::Name.name)
        fill_in('topic[name]', with: 'I got problems')
        fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
        click_on('Create Ticket')
      end
    # end

    #assert current_path == "/en/topics/#{Topic.last.id}-i-got-problems/posts"
    #assert current_path == "/en/thanks"

  end

  test "a browsing user who is registered should be able to create a private ticket via the web interface" do

    # create new private ticket
    visit '/en/topics/new/'

    # A new user should not be created
    assert_difference('User.count', 0) do
      assert_difference('Topic.count',1) do
        fill_in('topic_user_email', with: 'scott.miller@test.com')
        fill_in('topic[user][name]', with: 'Scott Miller')
        fill_in('topic[name]', with: 'I got problems')
        fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
        click_on('Create Ticket')
      end
    end

  end

  test "a browsing user should be prompted to login from a public forum page" do

    forums = [  "/en/community/3-public-forum/topics",
                "/en/community/4-public-idea-board/topics",
                "/en/community/5-public-q-a/topics" ]

    forums.each do |forum|
      visit forum
      click_on "Start a Discussion"
      assert find("div#login-modal").visible?
    end
  end

  test "a browsing user should be prompted to login when clicking reply from a public discussion view" do

    topics = [ "/en/topics/5-new-public-topic/posts",
               "/en/topics/8-new-idea/posts",
               "/en/topics/7-new-question/posts" ]

    topics.each do |topic|
      visit topic
      click_on "Reply"
      assert find("div#login-modal").visible?
    end
  end

  test "a browsing user should be able to create a private ticket via widget" do

    visit '/widget'

    assert_difference('Post.count', 1) do
      fill_in('topic_user_email', with: Faker::Internet.email)
      fill_in('topic_user_name', with: Faker::Name.name)
      fill_in('topic[name]', with: 'I got problems')
      fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
      click_on('Create Ticket')
    end

  end

  test "a browsing user should be prompted to login when clicking flag for review from a public discussion view" do
    visit '/en/topics/5-new-public-topic/posts'
    click_on "Flag for Review"
    assert find("div#login-modal").visible?
  end


end
