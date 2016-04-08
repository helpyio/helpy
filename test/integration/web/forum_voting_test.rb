require 'integration_test_helper'
include Warden::Test::Helpers

class ForumVotingTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in

    blacklist_urls

  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "a logged in user should be able to vote on a topic on the table view index" do

    visit "/en/community/3-public-forum/topics"
    within first('div.topic-points') do
      click_link "0"
    end
    sleep(1)
    within first('a.topic-vote') do
      assert page.has_content?("1")
    end

  end

  test "a logged in user should be able to vote on a topic on the idea view index" do

    visit "/en/community/4-public-idea-board/topics"
    within first('div#post-vote-8') do
      click_link "Upvote | 0"
    end
    sleep(1)
    visit "/en/community/4-public-idea-board/topics"
    within first('a.topic-vote') do
      assert page.has_content?("Upvote | 1")
    end

  end

  test "a logged in user should be able to vote on a topic on the question view" do

    visit "/en/community/5-public-q-a/topics"
    within first('div#post-vote-7') do
      click_link "Upvote | 0"
    end
    sleep(1)
    visit "/en/community/5-public-q-a/topics"
    within first('div#post-vote-7') do
      assert page.has_content?("Upvote | 1")
    end

  end

end
