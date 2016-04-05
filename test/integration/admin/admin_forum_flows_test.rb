require 'integration_test_helper'
include Warden::Test::Helpers

class AdminForumFlowsTest < ActionDispatch::IntegrationTest

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
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end

  test "an admin should be able to manage community forums" do

    assert current_path == "/admin"

    click_link 'Communities'
    sleep(1)

    assert page.has_content?("Admin Communities")
    assert page.has_content?("Create New Community")

    within first(".forum") do
      find(".glyphicon-align-justify").click
      sleep(2)
      assert find_link("Edit")
      assert find_link("Delete")
    end

    # This is to avoid a weird poltergeist error and is not needed for the test
    click_link("Edit")

  end

  test "an admin should be able to add and edit a community forum" do

    assert current_path == "/admin"

    click_link 'Communities'

    # First create category
    click_link "Create New Community"
    fill_in("forum_name", with: "New Forum")
    fill_in("forum_description", with: "This is the description")
    select("Table", from: "forum_layout")
    check("forum_allow_topic_voting")
    check("forum_allow_post_voting")
    click_on("Save Changes")

    # Now we will edit it
    assert current_path == "/admin/communities"
    assert page.has_content?("Admin Communities")

    within first(".forum") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    fill_in("forum_name", with: "New Forum (edited)")
    fill_in("forum_description", with: "This is the description (edited)")
    select("Table", from: "forum_layout")
    uncheck("forum_allow_topic_voting")
    uncheck("forum_allow_post_voting")
    click_on("Save Changes")

    assert current_path == "/admin/communities"
    assert page.has_content?("New Forum (edited)")
  end

  test "an admin should be able to delete a Forum" do

    assert current_path == "/admin"

    click_link 'Communities'

    # First create forum
    click_link "Create New Community"
    fill_in("forum_name", with: "New Forum")
    fill_in("forum_description", with: "This is the description")
    select("Table", from: "forum_layout")
    check("forum_allow_topic_voting")
    check("forum_allow_post_voting")
    click_on("Save Changes")
    sleep(1)

    within first(".forum") do
      find(".glyphicon-align-justify").click
      sleep(1)
      click_on("Delete")
      sleep(1)
      execute_script "$('a.btn.proceed.btn-primary').click()"
      sleep(1)
    end

    assert page.has_content?("Admin Communities")
  end

end
