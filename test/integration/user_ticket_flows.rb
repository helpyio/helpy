require 'integration_test_helper'
include Warden::Test::Helpers

class UserTicketFlows < ActionDispatch::IntegrationTest

  setup do
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  teardown do
    Warden.test_reset!
  end

  test "a browsing user should be able to create a private ticket via the web interface" do

    # make sure logged out
    logout(:user)

    # create new private ticket
    visit '/en/topics/new/'

    assert_difference('User.count', 1) do
      assert_difference('Topic.count',1) do
        fill_in('topic_user_email', with: 'test@test.com')
        fill_in('topic[user][name]', with: 'John Smith')
        fill_in('topic[name]', with: 'I got problems')
        fill_in('post[body]', with: 'Please help me!!')
        click_on('Start Discussion')
      end
    end

  end

  test "a signed in user should be able to create a private ticket via the web interface" do

    # sign in user
    sign_in_user

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
    sign_in_user

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

  def sign_in_user

    visit "/en/users/sign_in"
    within first('form#new_user') do
      fill_in("user[email]", with: 'scott.miller@test.com')
      fill_in("user[password]", with: '12345678')
      click_on('Sign in')
    end

  end


end
