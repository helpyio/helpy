require 'integration_test_helper'
include Warden::Test::Helpers

class AdminTicketFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in("admin@test.com")
  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.use_default_driver
  end

  def create_discussion
    click_on "New Discussion"

    fill_in("topic_user_email", with: "scott.smith@test.com")
    fill_in("topic_user_name", with: "Scott Smith")
    fill_in("topic_name", with: "New test message from admin form")
    fill_in("post_body", with: "This is the message")
    click_on "Start Discussion"
  end

  test "an admin should be able to create a new private discussion via the admin form" do

    create_discussion
    sleep(1)
    click_on "New"
    sleep(1)

    assert page.has_content?("#{Topic.last.id}- New test message from admin form")
  end

  test "an admin should see a list of pending discussions and be able to navigate between types" do
    assert current_path == "/admin"
    assert page.has_content?("PENDING")

    within("div#admin-stats") do
      ["New", "Open", "Pending", "Resolved"].each do |status|
        click_on("#{status}")
        assert page.has_content?("#{status.upcase}")
      end
    end
  end

  test "an admin should be able to select multiple discussions and assign them or change their status" do
    assert current_path == "/admin"

    # First we'll reassign all open discussions
    click_on("Open")
    sleep(2)
    check("check-all")
    sleep(2)
    assert page.has_content?("#{Topic.open.count} SELECTED MESSAGES")
    find("span.ticket-agent").click
    click_link("Admin User (2)")
    sleep(2)
    assert page.has_no_content?("unassigned")
    assert_equal(0, Topic.open.count)

    # Next lets mark all new discussions resolved
    click_on("New")
    sleep(2)
    check("check-all")
    sleep(2)
    assert page.has_content?("#{Topic.unread.count} SELECTED MESSAGES")
    find("span.ticket-status").click
    click_link("Mark Resolved")
    sleep(2)
    assert_equal(0, Topic.unread.count)

  end

  test "an admin should be able to click on a listed discussion to view and reply to it" do
    assert current_path == "/admin"

    create_discussion

    sleep(1)
    click_on("New")
    sleep(1)
    click_on("##{Topic.last.id}- #{Topic.last.name}")
    assert page.has_content?("Reply to this Topic")

    # Reply with text
    assert_difference('Post.count', 1) do
      fill_in("post_body", with: "This is a reply, check it out")
      click_on("Post Reply")
      sleep(1)
    end
    assert page.has_content?("Admin User replied...")

    # Reply with internal note
    assert_difference('Post.count', 1) do
      choose("post_kind_note")
      fill_in("post_body", with: "This is an internal note")
      click_on("Post Reply")
      sleep(1)
    end
    assert page.has_content?("Admin User posted an internal note...")
    assert page.has_content?("1 collapsed message")
    assert page.has_content?("This is an internal note")

    #Reply with common reply
    assert_difference('Post.count', 1) do
      select('Article 1', from: 'post_reply_id')
      click_on("Post Reply")
      sleep(1)
    end
    assert page.has_content?("2 collapsed messages")
    assert page.has_content?("article1 text")
  end

  test "an admin should be able to edit, deactivate and turn a post into content" do

    create_discussion
    sleep(1)
    click_on("New")
    sleep(1)
    click_on("##{Topic.last.id}- #{Topic.last.name}")
    sleep(1)
    assert page.has_content?("Reply to this Topic")

    # Reply with text
    assert_difference('Post.count', 1) do
      fill_in("post_body", with: "Currently, Active Record suppresses errors raised within `after_rollback`/`after_commit` callbacks and only print them to the logs. In the next version, these errors will no longer be suppressed. Instead, the errors will propagate normally just like in other Active Record callbacks.")
      click_on("Post Reply")
      sleep(1)
    end

    @post = Post.last

    # Edit the reply
    within("div#post-#{@post.id}") do
      find('span.post-tools').click
      #click_on("Admin User replied...")
      sleep(1)
      click_link 'Edit'
      fill_in('post_body', with: "That was way too long, lets try something shorter... Currently, Active Record suppresses errors raised within... blah blah")
      click_on("Save Changes")
    end

    assert page.has_content?("blah blah")

    # Make this message public
    find("span.ticket-forum").click
    click_link "Move: Public Forum"
    sleep(1)
    assert page.has_content?("PUBLIC")

    # Make the reply inactive and verify it is not visible onsite
    within("div#post-#{@post.id}") do
      find('span.post-tools').click
      #click_on("Admin User replied...")
      sleep(1)
      click_link 'Edit'
      uncheck("post_active")
      click_on("Save Changes")
    end

    visit('/en/topics/9-new-test-message-from-admin-form/posts')
    assert page.has_no_content?("That was way too long, lets try something shorter")


  end

  test "an admin should be able to change status, privacy or assignment of a discussion from the detailed view" do
    assert current_path == "/admin"

    @admin = User.find(1)

    #first create a new message to work with
    create_discussion

    #Now view it
    sleep(1)
    click_on("New")
    sleep(3)
    click_on("##{Topic.last.id}- #{Topic.last.name}")

    #Next, assign the message to admin
    sleep(2)
    find("span.ticket-agent").click
    click_link "Admin User (#{@admin.active_assigned_count})"
    sleep(1)
    assert page.has_content?("Discussion has been transferred to Admin User.")

    #Now make it public
    find("span.ticket-forum").click
    click_link "Move: Public Forum"
    sleep(1)
    assert page.has_content?("PUBLIC")

    #And last, change its status to resolved
    find("span.ticket-status").click
    click_link "Mark Resolved"
    sleep(1)
    assert page.has_content?("This ticket has been closed by the support staff.")

  end

end
