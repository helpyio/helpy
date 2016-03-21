require 'integration_test_helper'
include Warden::Test::Helpers

class AdminCategoryFlowsTest < ActionDispatch::IntegrationTest

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
  end

  test "an admin should be able to add and edit a knowledgebase category" do

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

    # Now translate into French
    within("tr#category-1") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    # Select Francais
    select("Français", from: 'lang')

    fill_in("category_name", with: "En Français")
    fill_in("category_keywords", with: "Français")
    fill_in("category_title_tag", with: "Français")
    fill_in("category_meta_description", with: "Français")
    click_on("Update Category")

    # Verify FR is active
    within("tr#category-1") do
      page.has_css?("span.badge.FR")
    end

  end

=begin

  test "an admin should be able to add, edit, and delete a knowledgebase document" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create content
    click_link "New Content"
    assert_difference('Doc.count', 1) do
      fill_in("doc_title", with: "New Article")
      select("active and featured", from: "doc_category_id")
      fill_in("doc_body_trix_input_doc", with: "This is the article content")
      fill_in("doc_keywords", with: "Keywords")
      fill_in("doc_title_tag", with: "Title")
      fill_in("doc_meta_description", with: "This is the description")
      check("doc_front_page")
      choose("true", from: "doc_active")
      click_on("Save Changes")
    end

    # Now we will edit it
    assert current_path == "/admin/content/1/articles"
    #assert page.has_content?("active and featured")
    @doc = Doc.where(name: "New Article").first

    within("tr#doc-#{@category.id}") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    #assert current_path == "/admin/knowledgebase/#{@category.id}/edit?lang=en&locale=en"
    assert page.has_content?("Edit: New Article")

    fill_in("doc_title", with: "New Article (edited)")
    select("active_and_featured", from: "doc_category_id")
    fill_in("doc_body_trix_input_doc", with: "This is the article content (edited)")
    fill_in("doc_keywords", with: "Keywords (edited)")
    fill_in("doc_title_tag", with: "Title (edited)")
    fill_in("doc_meta_description", with: "This is the description (edited)")
    check("doc_front_page")
    choose("true", from: "doc_active")
    click_on("Save Changes")

    assert current_path == "/admin/content/1/articles"

  end

=end

  test "an admin should be able to delete a category" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create category
    click_link "New Category"
    assert_difference('Category.count', 1) do
      fill_in("category_name", with: "Deleteable Category")
      fill_in("category_icon", with: "align-justify")
      fill_in("category_keywords", with: "Keywords")
      fill_in("category_title_tag", with: "Title")
      fill_in("category_meta_description", with: "This is the description")
      check("category_front_page")
      click_on("Create Category")
    end
    sleep(1)
    @cat = Category.where(name: 'Deleteable Category').first

    click_link 'Content'
    assert_difference('Category.count', -1) do
      within("tr#category-#{@cat.id}") do
        find(".glyphicon-align-justify").click
        sleep(1)
        click_on("Delete")
        sleep(1)
        execute_script "$('a.btn.proceed.btn-primary').click()"
        sleep(1)
      end
    end
  end

end
