require 'integration_test_helper'
include Warden::Test::Helpers

class AdminTicketFlowsTest < ActionDispatch::IntegrationTest

  fixtures :all

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in("admin@test.com")

    blacklist_urls

  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  def admin_create_discussion(name = "New test message from admin form")
    click_on "New Discussion"
    sleep(2)

    fill_in("topic_user_email", with: "scott.smith@test.com")
    fill_in("topic_user_name", with: "Scott Smith")
    fill_in("topic_name", with: name)
    fill_in("post_body", with: "This is the message")
    sleep(1)
    #find(".submit-start-discussion").click
    execute_script("$('.submit-start-discussion')[0].click()")
    sleep(2)

    @ticket = Topic.where(name: name).last

    # @ticket = Topic.create!(
    #   forum_id: 1,
    #   user_id: 3,
    #   name: name,
    #   locale: 'en'
    # )
    # sleep(2)
    # @ticket.posts.create!(
    #   user_id: 3,
    #   body: "This is the message",
    #   kind: 'first'
    # )

    sleep(2)

  end

  def visit_message_detail(ticket = 1)
    # Jump directly to ticket detail via search
    fill_in('q', with: 1)
    execute_script "$('form.navbar-form.navbar-right').submit()"
    sleep(2)
    assert page.has_content?("#1- Private topic")
    click_on("#1- Private topic")
    # ind("a.topic-link").click
    sleep(1)
  end

  test "an admin should be able to create a new private discussion via the admin form" do

    create_discussion("New Discussion")

    click_on "New"
    sleep(2)

    assert page.has_content?("#{@new_topic.name}")
  end

  # test "an admin should see a list of pending discussions and be able to navigate between types" do
  #   assert current_path == "/admin"
  #   assert page.has_content?("PENDING")
  #
  #   within("div#admin-stats") do
  #     ["New", "Open", "Pending", "Resolved"].each do |status|
  #       click_on("#{status}")
  #       assert page.has_content?("#{status.upcase}")
  #     end
  #   end
  # end
  #
  # test "an admin should be able to select multiple discussions and assign them" do
  #   assert current_path == "/admin"
  #
  #   # First we'll reassign all open discussions
  #   click_on("Resolved")
  #   sleep(2)
  #   check("check-all")
  #   sleep(2)
  #
  #   #assert page.has_content?("1 SELECTED MESSAGE")
  #   find("span.ticket-agent").click
  #   click_link("Admin User")
  #   sleep(2)
  #   assert page.has_no_content?("unassigned")
  #   #@open = Topic.open.count
  #   #assert_equal(0, @open)
  # end
  #
  # test "an admin should be able to select multiple discussions change their status" do
  #   assert current_path == "/admin"
  #
  #   # First we'll reassign all open discussions
  #   click_on("Resolved")
  #   sleep(2)
  #   check("check-all")
  #   sleep(2)
  #
  #   # Next lets mark all new discussions resolved
  #   click_on("Pending")
  #   sleep(2)
  #   check("check-all")
  #   sleep(2)
  #   #assert page.has_content?("2 SELECTED MESSAGES")
  #   find("span.ticket-status").click
  #   click_link("Mark Resolved")
  #
  # end

  test "an admin should be able to click on a listed discussion to view it" do
    assert current_path == "/admin"

    create_discussion("New test message from admin form")

    click_on("New")
    sleep(1)
    #click_on("##{@ticket.id}- New test message from admin form")

    within("tr#topic-#{@new_topic.id}") do
      find(".topic-link").click
    end

    sleep(1)
    assert page.has_content?("Reply to this Topic")

  end

  test "an admin should be able to click on a listed discussion to reply to it" do

    create_discussion("Discussion for a reply")

    click_on("New")
    sleep(1)
#    click_on("##{@ticket.id}- Discussion for a reply")
    within("tr#topic-#{@new_topic.id}") do
      find(".topic-link").click
    end

    sleep(1)
    assert page.has_content?("Reply to this Topic")

    # Reply with text
    fill_in("post_body", with: "This is a reply, check it out")
    sleep(1)
    find(".submit-post-reply").click
    sleep(1)
    assert page.has_content?("Admin User replied...")

  end

  test "an admin should be able to click on a listed discussion and post an internal note to it" do

    create_discussion("Discussion for internal note")

    click_on("New")
    sleep(1)
    within("tr#topic-#{@new_topic.id}") do
      #click_on("##{@ticket.id}- Discussion for internal note")
      find(".topic-link").click
    end
    sleep(1)
    assert page.has_content?("Reply to this Topic")

    # Reply with internal note
    choose("post_kind_note")
    fill_in("post_body", with: "This is an internal note")
    sleep(1)
    find(".submit-post-reply").click
    sleep(2)

    assert page.has_content?("Admin User posted an internal note...")
    assert page.has_content?("This is an internal note")
  end

  test "an admin should be able to click on a listed discussion and reply with a common reply" do

    create_discussion("Discussion for common reply")

    click_on("New")
    sleep(1)
#    click_on("##{@ticket.id}- Discussion for common reply")
    within("tr#topic-#{@new_topic.id}") do
      find(".topic-link").click
    end

    sleep(1)
    assert page.has_content?("Reply to this Topic")

    #Reply with common reply
    select('Article 1', from: 'post_reply_id')
    find(".submit-post-reply").click
    sleep(1)

    assert page.has_content?("article1 text")
  end

#   test "an admin should be able to edit deactivate and turn a post into content" do
#
#     admin_create_discussion("Discussion for post")
#
#     click_on("New")
#     sleep(2)
#     within("tr#topic-#{@ticket.id}") do
#       find(".topic-link").click
#     end
#
# #    click_on("##{@ticket.id}- Discussion for post")
#     sleep(2)
#     assert page.has_content?("Reply to this Topic")
#
#     # Reply with text
#     fill_in("post_body", with: "Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit` callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will propagate normally just like in other Active Record callbacks.")
#     sleep(1)
#     find(".submit-post-reply").click
#     sleep(1)
#
#     # Edit the reply
#     page.first("span", text: "Admin User replied...").click
#     sleep(1)
#     click_link 'Edit'
#     sleep(1)
#     within('div.post-container.kind-reply') do
#       fill_in('post_body', with: "That was way too long, lets try something shorter... Currently, Active Record suppresses errors raised within... blah blah")
#       click_on("Save Changes")
#     end
#     sleep(1)
#     assert page.has_content?("That was way too long, lets try something shorter... Currently, Active Record suppresses errors raised within... blah blah")
#
#     # Make this message public
#     find("span.ticket-forum").click
#     click_link "Move: Public Forum"
#     sleep(1)
#     assert page.has_content?("PUBLIC")
#
#     within('div.post-container.kind-reply') do
#       page.first("span", text: "Admin User replied...").click
#       sleep(1)
#       click_link 'Edit'
#       uncheck("post_active")
#       click_on("Save Changes")
#     end
#
#     visit('/en/topics/7-new-question/posts')
#     assert page.has_no_content?("That was way too long, lets try something shorter")
#
#
#   end
#
#   test "an admin should be able to change assignment of a discussion from the detailed view" do
#     assert current_path == "/admin"
#
#     visit_message_detail
#
#     #Next, assign the message to admin
#     find("span.ticket-agent").click
#     click_link "Admin User"
#
#     sleep(2)
#     assert page.has_content?("Discussion has been transferred to Admin User.")
#   end
#
#   test "an admin should be able to change privacy of a discussion from the detailed view" do
#     assert current_path == "/admin"
#
#     visit_message_detail
#
#     #Make it public
#     find("span.ticket-forum").click
#     click_link "Move: Public Forum"
#     sleep(2)
#     assert page.has_content?("PUBLIC")
#
#   end
#
#   test "an admin should be able to change status of a discussion from the detailed view" do
#     assert current_path == "/admin"
#
#     visit_message_detail
#
#     #Change its status to resolved
#     find("span.ticket-status").click
#     click_link "Mark Resolved"
#     sleep(2)
#     assert page.has_content?("This ticket has been closed by the support staff.")
#
#   end
end
