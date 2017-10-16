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

  test "a signed in user should be able to create a private ticket via the web interface" do

    sign_in

    visit '/en'
    visit '/en/topics/new/'

    assert page.has_content?(I18n.t(:should_message_be_private))

    assert_difference('Topic.count', 1) do
      choose(I18n.t(:only_support_can_respond))
      fill_in('topic[name]', with: 'I got problems')
      fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
      click_on(I18n.t(:submit_start_discussion), disabled: true)
    end

    visit '/en/tickets/'
    assert page.has_content?(I18n.t(:tickets))
    assert page.has_content?("##{Topic.last.id}- I got problems")

  end

  test "a signed in user should be able to create a public topic via the web interface" do

    sign_in

    visit '/en'
    visit '/en/topics/new/'

    assert page.has_content?(I18n.t(:should_message_be_private))

    assert_difference('Topic.count', 1) do
      choose(I18n.t(:responses_can_come_from_everyone))
      select('Public Forum', from: "topic[forum_id]")
      fill_in('topic[name]', with: 'I got problems')
      fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
      click_on(I18n.t(:submit_start_discussion), disabled: true)
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
      click_on I18n.t(:submit_reply), disabled: true
    end

#    assert page.has_content?('This is my reply'), "Reply not found"

  end

  test "a logged in user should be prompted to create a new public topic" do

    sign_in

    forums = [  "/en/community/3-public-forum/topics",
                "/en/community/4-public-idea-board/topics",
                "/en/community/5-public-q-a/topics" ]

    forums.each do |forum|
      visit forum
      click_on I18n.t(:start_discussion)
      assert current_path == "/en/topics/new"
    end

  end

  test "a logged in user should not see the reply button when viewing a public topic" do

    sign_in

    topics = [ "/en/topics/5-new-public-topic/posts",
               "/en/topics/8-new-idea/posts",
               "/en/topics/7-new-question/posts" ]

    topics.each do |topic|
      visit topic
      assert page.has_no_css?('#reply-button'), message: "Reply button displayed when it shouldnt be (url: #{topic})"
      assert page.has_content?('Type your response:')
    end

  end

  test "a signed in user should be able to reply to a public topic" do

    sign_in

    topics = [ "/en/topics/5-new-public-topic/posts",
               "/en/topics/8-new-idea/posts",
               "/en/topics/7-new-question/posts" ]

    topics.each do |topic|

      visit topic

      assert_difference('Post.count', 1) do
        fill_in "post_body", with: "This is my reply"
        click_on I18n.t(:submit_reply)
      end

      visit topic
      assert page.has_content?('This is my reply'), "Reply not found"

    end

  end

  test "a signed in user should be able to create a private ticket via widget" do

    sign_in

    visit '/widget'

    assert_difference('Post.count', 1) do
      fill_in('topic[name]', with: 'I got problems')
      fill_in('topic[posts_attributes][0][body]', with: 'Please help me!!')
      click_on(I18n.t(:submit_start_discussion), disabled: true)
    end

    visit '/en/tickets/'
    assert page.has_content?(I18n.t(:tickets))
    assert page.has_content?("##{Topic.last.id}- I got problems")

  end

  test "a signed in user should be able to flag a post for review from the public discussion view" do
    sign_in

    visit '/en/topics/5-new-public-topic/posts'
    click_on I18n.t(:flag_for_review)
    assert find("div#flag-modal").visible?
  end

end
