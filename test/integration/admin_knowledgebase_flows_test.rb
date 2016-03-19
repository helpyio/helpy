require 'integration_test_helper'
include Warden::Test::Helpers

class AdminKnowledgebaseFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    sign_in("admin@test.com")
  end

  def teardown
    Warden.test_reset!
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
      assert find_link("Edit")
      assert find_link("Delete")
      assert find_link("View and Edit Content")
      assert find_link("New Content")
    end

    visit '/'
    click_link 'Logout'
  end

  test "an admin should be able to add, edit, translate and delete a knowledgebase category" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create category
    click_link "New Category"
    assert_difference('Category.count', 1) do
      fill_in("category_name", with: "New Category")
      fill_in("category_icon", with: "align-justify")
      fill_in("category_keywords", with: "Keywords")
      fill_in("category_title_tag", with: "Title")
      fill_in("category_meta_description", with: "This is the description")
      check("category_front_page")
      click_on("Create Category")
    end

    # Now we will edit it
    assert current_path == "/admin/content"
    assert page.has_content?("New Category")
    @category = Category.where(name: "New Category").first

    sleep
    within("tr#category-#{@category.id}") do
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

    # Now translate into French
    within("tr#category-#{@category.id}") do
      click_on("Edit")
    end

    visit '/'
    click_link 'Logout'

  end

  test "an admin should be able to manage knowledgebase docs for a category" do

    assert current_path == "/admin"

    click_link 'Content'

    within("tr#category-1") do
      click_link "View and Edit Content"
    end

    assert current_path == "/admin/content/1/articles"
    assert page.has_content?("active and featured")
    assert page.has_content?("New Content")
    assert page.has_content?("New Category")

    # Should see available locales represented
    assert page.has_content?("EN")
    assert page.has_content?("FR")
    assert page.has_content?("ET")

    within("tr#doc-1") do
      assert find(".glyphicon-align-justify")
      assert find_link("Edit")
      assert find_link("Delete")
      assert find_link("View on Site")
    end

    visit '/'
    click_link 'Logout'

  end

#  test "an admin should be able to translate an article" do
#    Capybara.current_driver = Capybara.javascript_driver

#  end

end
