require 'integration_test_helper'
include Warden::Test::Helpers


class SignedInUserTicketFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
#    Capybara.current_driver = Capybara.javascript_driver
#    Capybara.default_wait_time = 30
  end

  def teardown
    Warden.test_reset!
  end

  test "a signed in user should be able to create a private ticket via the web interface" do

    # sign in user
    sign_in

    visit '/en'
    visit '/en/topics/new/'

    # make sure we get the signed in version
    assert page.has_content?('Should this message be private?')

    assert_difference('Topic.count', 1) do
      choose('Only support can respond (creates a private ticket)')
      fill_in('topic[name]', with: 'I got problems')
      fill_in('post[body]', with: 'Please help me!!')
      click_on('Start Discussion')
    end

    visit '/en/tickets/'
    assert page.has_content?('Tickets')
    assert page.has_content?("##{Topic.last.id}- I got problems")

  end

  test "a signed in user should be able to create a public topic via the web interface" do

    # sign in user
    sign_in

    visit '/en'
    visit '/en/topics/new/'

    # make sure we get the signed in version
    assert page.has_content?('Should this message be private?')

    assert_difference('Topic.count', 1) do
      choose('Responses can come from support or the community (recommended)')
      select('Public Forum', from: "topic[forum_id]")
      fill_in('topic[name]', with: 'I got problems')
      fill_in('post[body]', with: 'Please help me!!')
      click_on('Start Discussion')
    end

    visit '/en/community/3-public-forum/topics'
    assert page.has_content?("I got problems")

  end

  test "a signed in user should be able to reply to a private ticket" do

    sign_in

    visit '/en'
    visit '/en/tickets'

    assert page.has_content?('#1- Private topic')
    click_on('#1- Private topic')

    assert current_path == '/en/ticket/1-private-topic'
    assert_difference('Post.count', 1) do
      fill_in "post_body", with: "This is my reply"
      click_on "Post Reply"
    end

#    assert page.has_content?('This is my reply'), "Reply not found"

  end

  test "a logged in user should be prompted to create a new topic" do

    sign_in
    visit "/en/community/3-public-forum/topics"
    click_on "New Discussion"
    assert current_path == "/en/topics/new"

    visit "/en/community/4-public-idea-board/topics"
    click_on "New Discussion"
    assert current_path == "/en/topics/new"

    visit "/en/community/5-public-q-a/topics"
    click_on "New Discussion"
    assert current_path == "/en/topics/new"



  end


  def devise_sign_in
    user = User.where(email: "scott.miller@test.com").first
    login_as :user
  end

  def sign_in

    visit "/en/users/sign_in"
    within first('div.login-form') do
      fill_in("user[email]", with: 'scott.miller@test.com')
      fill_in("user[password]", with: '12345678')
      click_on('Sign in')
    end

  end

  def sign_in_by_modal

    within("div#above-header") do
      click_on "Sign in", wait: 30
    end
    within('div#login-modal') do
      fill_in("user[email]", with: 'scott.miller@test.com')
      fill_in("user[password]", with: '12345678')
#      within('div.login-button') do
        click_on('Sign in')
#      end
    end

  end

  def sign_out

    logout(:user)
#    within("div#above-header") do
#      first("Logout").click
#    end
  end

end
