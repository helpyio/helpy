require 'integration_test_helper'
include Warden::Test::Helpers

class AdminArticleFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en

    Capybara.current_driver = Capybara.javascript_driver
    sign_in("admin@test.com")

    page.driver.browser.url_blacklist = [
      'http://www.google.com',
      'http://google-analytics.com',
      'http://fonts.googleapis.com',
      'http://fonts.gstatic.com'
    ]

  end

  def teardown
    click_logout
    Warden.test_reset!
    Capybara.use_default_driver
  end

  def create_doc(title = "New Article")
    fill_in("doc_title", with: title)
    select("active and featured", from: "doc_category_id")
    execute_script('$("trix-editor").html("This is the article content")')
    fill_in("doc_keywords", with: "Keywords")
    fill_in("doc_title_tag", with: "Title")
    fill_in("doc_meta_description", with: "This is the description")
    check("doc_front_page")
    choose("doc_active_true")
    click_on("Save Changes")
    sleep(1)

    @doc = Doc.where(title: title).first
  end

  test "an admin should be able to manage knowledgebase docs for a category" do

    assert current_path == "/admin"

    click_link 'Content'

    within("tr#category-1") do
      find(".glyphicon-align-justify").click
      click_link "View and Edit Content"
    end

    #assert current_path == "/admin/content/1/articles"
    assert page.has_content?("active and featured")
    assert page.has_content?("New Content")
    assert page.has_content?("New Category")

    # Should see available locales represented
    assert page.has_content?("EN")
    assert page.has_content?("FR")
    assert page.has_content?("ET")

    within("tr#doc-1") do
      find(".glyphicon-align-justify").click
      sleep(1)
      assert find_link("Edit"), "Edit not found"
      assert find_link("Delete"), "Delete not found"
      assert find_link("View on Site"), "View on site not found"

      # This is to avoid a weird poltergeist error and is not needed for the test
      click_link("Edit")
    end

  end

  test "an admin should be able to add and edit a knowledgebase document" do

    assert current_path == "/admin"
    click_link 'Content'

    sleep(1)

    # First create content
    click_link "New Content"
    #assert_difference('Doc.count', 1) do
      create_doc
    #end

    # Now we will edit it
    assert current_path == "/admin/content/1/articles"
    assert page.has_content?("active and featured")
    @doc = Doc.where(title: "New Article").first

    within("tr#doc-#{@doc.id}") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    assert page.has_content?("Edit: New Article")

    fill_in("doc_title", with: "New Article (edited)")
    select("active and featured", from: "doc_category_id")
    execute_script('$("trix-editor").html("This is the article content (edited)")')
    fill_in("doc_keywords", with: "Keywords (edited)")
    fill_in("doc_title_tag", with: "Title (edited)")
    fill_in("doc_meta_description", with: "This is the description (edited)")
    check("doc_front_page")
    choose("doc_active_true")
    click_on("Save Changes")

    assert current_path == "/admin/content/1/articles"

  end

  test "an admin should be able to delete an article" do

    assert current_path == "/admin"
    click_link 'Content'

    sleep(1)
    click_link "New Content"

    #assert_difference('Doc.count', 1) do
      create_doc
    #end

    click_link 'Content'
    within("tr#category-1") do
      find(".glyphicon-align-justify").click
      click_link "View and Edit Content"
    end

    @doc = Doc.where(title: "New Article").first

    #assert_difference('Doc.count', -1) do
      within("tr#doc-#{@doc.id}") do
        find(".glyphicon-align-justify").click
        sleep(1)
        click_on("Delete")
        sleep(1)
        execute_script "$('a.btn.proceed.btn-primary').click()"
        sleep(1)
      end
    #end
  end

  test "an admin should be able to translate a doc" do

    assert current_path == "/admin"

    click_link 'Content'

    # First create content
    click_link "New Content"

    fill_in("doc_title", with: "Translate This")
    select("active and featured", from: "doc_category_id")
    execute_script('$("trix-editor").html("This is the article content")')
    fill_in("doc_keywords", with: "Keywords")
    fill_in("doc_title_tag", with: "Title")
    fill_in("doc_meta_description", with: "This is the description")
    check("doc_front_page")
    choose("doc_active_true")
    click_on("Save Changes")
    sleep(1)

    @doc = Doc.where(title: 'Translate This').first

    #create_doc
    sleep(3)

    # Now we will edit it
    assert current_path == "/admin/content/#{@doc.category.id}/articles"
    assert page.has_content?("active and featured")
    @doc = Doc.last

    within("tr#doc-#{@doc.id}") do
      find(".glyphicon-align-justify").click
      click_on("Edit")
    end

    # Select Francais
    select("Français", from: 'lang')
    sleep(3)

    fill_in("doc_title", with: "En Français")
    execute_script('$("trix-editor").html("En Français")')
    fill_in("doc_keywords", with: "Français")
    fill_in("doc_meta_description", with: "Français")
    fill_in("doc_title_tag", with: "Title")
    click_on("Save Changes")

    # Verify FR is active
    within("tr#doc-#{@doc.id}") do
      page.has_css?("span.badge.FR")
    end


  end

end
