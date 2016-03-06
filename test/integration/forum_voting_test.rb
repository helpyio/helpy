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

  test "a logged in user should be able to vote on a topic from the topic index view" do

    sign_in

    visit "/en/community/3-public-forum/topics"
    assert_difference('Topic.find(4).points') do
      within first('div.topic-points') do
        click_link "0"
      end
    end
    visit "/en/community/3-public-forum/topics"
    within ('tr#topic_4') do
      assert page.has_content?("1")
    end


    visit "/en/community/4-public-idea-board/topics"
    assert_difference('Topic.find(8).points') do
      within first('div#post-vote-8') do
        click_link "Upvote | 0"
      end
    end
    visit "/en/community/4-public-idea-board/topics"
    within first('a.topic-vote') do
      assert page.has_content?("Upvote | 1")
    end


    visit "/en/community/5-public-q-a/topics"
    assert_difference('Topic.find(7).points') do
      within first('div#post-vote-7') do
        click_link "Upvote | 0"
      end
    end
    visit "/en/community/5-public-q-a/topics"
    within first('div#post-vote-7') do
      assert page.has_content?("Upvote | 1")
    end
  end

  test "a logged in user should be able to vote on a reply from the topic detail view" do

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
