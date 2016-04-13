require 'integration_test_helper'

include Warden::Test::Helpers

class SignedInUserTicketFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    set_default_settings
  end

  def teardown
    Capybara.reset_sessions!
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
    within 'tr#topic_4' do
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

end
