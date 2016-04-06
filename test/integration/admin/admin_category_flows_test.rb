require 'integration_test_helper'
include Warden::Test::Helpers

class AdminCategoryFlowsTest < ActionDispatch::IntegrationTest

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

  def create_category(name = "New Category")
    within("span.admin-options") do
      click_link "New Category"
    end

    fill_in("category_name", with: name)
    fill_in("category_icon", with: "align-justify")
    fill_in("category_keywords", with: "Keywords")
    fill_in("category_title_tag", with: "Title")
    fill_in("category_meta_description", with: "This is the description")
    check("category_front_page")
    click_on("Create Category")
    sleep(2)

    # Set instance variable of the new category
    @category = Category.where(name: name).first
  end

  test "an admin should be able to manage knowledgebase categories" do

    assert current_path == "/admin"

    click_link 'Content'

    assert page.has_content?("New Content")
    assert page.has_content?("New Category")

    # Should see available locales represented
    assert page.has_content?("EN")
    assert page.has_content?("FR")
    assert page.has_content?("ET")

    within("tr#category-1") do
      find(".glyphicon-align-justify").click
      sleep(1)
      assert find_link("Edit")
      assert find_link("Delete")
      assert find_link("View and Edit Content")
      assert find_link("New Content")
    end

    #This is for poltergeist
    click_on("Edit")
  end

  test "an admin should be able to add a knowledgebase category" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create category
    create_category

    # Make sure new category is displayed
    assert page.has_content?("#{@category.name}")


  end

  test "an admin should be able to edit a knowledgebase category" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create category
    create_category

    # Now we will edit it
    assert current_path == "/admin/content"
    assert page.has_content?("New Category")

    within("tr#category-#{@category.id}") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end
    #assert current_path == "/admin/knowledgebase/#{@category.id}/edit?lang=en&locale=en"
    fill_in("category_name", with: "Updated Category")
    fill_in("category_icon", with: "align-justify")
    fill_in("category_keywords", with: "New Keywords")
    fill_in("category_title_tag", with: "New Title")
    fill_in("category_meta_description", with: "This is the description")
    click_on("Update Category")

    assert current_path == "/admin/content"
    assert page.has_content?("Updated Category")

  end

  test "an admin should be able to translate a category" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create category
    create_category("Translate This")

    # Now translate into French
    within("tr#category-#{@category.id}") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    # Select Francais
    select("Français", from: 'lang')
    sleep(3)
    fill_in("category_name", with: "En Français")
    fill_in("category_icon", with: "En Français")
    fill_in("category_keywords", with: "align-justify")
    fill_in("category_title_tag", with: "Français")
    fill_in("category_meta_description", with: "Français")
    click_on("Update Category")

    # Verify FR is active
    within("tr#category-#{@category.id}") do
      page.has_css?("span.badge.FR")
    end

  end

  test "an admin should be able to delete a category" do

    assert current_path == "/admin"
    click_link 'Content'

    # First create category
    create_category
    sleep(3)

    within("tr#category-#{@category.id}") do
      find("span.glyphicon-align-justify").click
      sleep(2)
      click_on("Delete")
      sleep(1)
      execute_script "$('a.btn.proceed.btn-primary').click()"
      sleep(1)
    end

  end
end
