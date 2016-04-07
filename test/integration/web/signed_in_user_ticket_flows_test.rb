require 'integration_test_helper'
include Warden::Test::Helpers

class SignedInUserTicketFlowsTest < ActionDispatch::IntegrationTest

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

  test "a signed in user should be able to create a private ticket via the web interface" do

    visit '/en'
    visit '/en/topics/new/'

    assert page.has_content?('Should this message be private?')

    choose('Only support can respond (creates a private ticket)')
    fill_in('topic[name]', with: 'I got problems')
    fill_in('post[body]', with: 'Please help me!!')
    execute_script("$('form.new_topic').submit()")

    visit '/en/tickets/'
    assert page.has_content?('Tickets')
    assert page.has_content?("##{Topic.last.id}- I got problems")

  end

  test "a signed in user should be able to create a public topic via the web interface" do

    visit '/en'
    visit '/en/topics/new/'

    assert page.has_content?('Should this message be private?')

    choose('Responses can come from support or the community (recommended)')
    select('Public Forum', from: "topic[forum_id]")
    fill_in('topic[name]', with: 'I got problems')
    fill_in('post[body]', with: 'Please help me!!')
    execute_script("$('form.new_topic').submit()")

    visit '/en/community/3-public-forum/topics'
    assert page.has_content?("I got problems")

  end

  test "a signed in user should be able to reply to a private ticket" do

    visit '/en/tickets'

    sleep(2)
    assert page.has_content?('Tickets')
    within("table#topics") do
      first("a.ticket-link").click
    end
    assert page.has_content?('Ticket Number')

    fill_in "post_body", with: "This is my reply"
    execute_script("$('form.new_post').submit()")

#    assert page.has_content?('This is my reply'), "Reply not found"

  end

  test "a logged in user should be prompted to create a new public topic" do

    forums = [  "/en/community/3-public-forum/topics",
                "/en/community/4-public-idea-board/topics",
                "/en/community/5-public-q-a/topics" ]

    forums.each do |forum|
      visit forum
      assert page.has_content?("New Discussion")
    end

  end

  test "a logged in user should not see the reply button when viewing a public topic" do

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

    topics = [ "/en/topics/5-new-public-topic/posts",
               "/en/topics/8-new-idea/posts",
               "/en/topics/7-new-question/posts" ]

    topics.each do |topic|

      visit topic

      fill_in "post_body", with: "This is my reply"
      execute_script("$('form.new_post').submit()")

      visit topic
      assert page.has_content?('This is my reply'), "Reply not found"

    end

  end

end
