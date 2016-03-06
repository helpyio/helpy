require 'integration_test_helper'
include Warden::Test::Helpers


class BrowsingUserTicketFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
    logout(:user)
#    Capybara.current_driver = Capybara.javascript_driver
#    Capybara.default_wait_time = 30
  end

  def teardown
#    logout(:user)
    Warden.test_reset!
  end

  test "a browsing user who is not registered should be able to create a private ticket via the web interface" do

    # create new private ticket
    visit '/en/topics/new/'

    # a new user should be created
    assert_difference('User.count', 1) do
      assert_difference('Topic.count',1) do
        fill_in('topic_user_email', with: 'test@test.com')
        fill_in('topic[user][name]', with: 'John Smith')
        fill_in('topic[name]', with: 'I got problems')
        fill_in('post[body]', with: 'Please help me!!')
        click_on('Start Discussion')
      end
    end

    assert current_path == '/en/users/sign_in'

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
        fill_in('post[body]', with: 'Please help me!!')
        click_on('Start Discussion')
      end
    end

  end

  test "a browsing user should be prompted to login from a forum page" do

    visit "/en/community/3-public-forum/topics"
    click_on "New Discussion"
    assert find("div#login-modal").visible?

    visit "/en/community/4-public-idea-board/topics"
    click_on "New Discussion"
    assert find("div#login-modal").visible?

    visit "/en/community/5-public-q-a/topics"
    click_on "New Discussion"
    assert find("div#login-modal").visible?

  end

end
