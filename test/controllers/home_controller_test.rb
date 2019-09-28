require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a browsing user in the default locale should be able to load home page" do
    get :index, locale: :en
    assert_response :success
  end

  test "a browsing user in an alternate locale should be able to load home page" do
    get :index, locale: :fr
    assert_response :success
  end

  test "a browsing user should see a selector for locale if there are alternate locales" do
    get :index, locale: :en
    assert_select "span.select-locale", true
  end

  test "a browsing user should not see a selector for locale if there are no alternate locales" do
    AppSettings["i18n.available_locales"] = ["en"]

    get :index, locale: :en
    assert_select "span.select-locale", false, "Should not have found locale selector"
  end

  test "a browsing user should see the correct template when visiting the home page" do
    get :index, locale: :en
    assert_template layout: "layouts/#{AppSettings['theme.active']}"
  end

  # There are two categories in the test data, one is featured on home page
  test "a browsing user in the default locale should see a home page featuring at least one category" do
    get :index, locale: :en
    assert_not_nil assigns(:categories)

    #Should be at least one category box
    assert_select "div.topic-box", true
  end

  # If there are no translations for a given locale, no category boxes should be displayed
  test "a browsing user in a locale without translations should not see any category" do
    get :index, locale: :fr

    #Should not be any category boxes
    assert_select "div.topic-box", false
  end

  # Even if there is a translated category for the current locale, if there are no translated docs in that category,
  # No category boxes should be shown
  test "a browsing user in a locale with a translated category but without translated docs should not see any category" do
    get :index, locale: :et

    #Should not be any category boxes
    assert_select "div.topic-box", false
  end

  # If there is a translated category with at least one translated doc, a category box should be shown
  test "a browsing user in a locale with a translated category with translated docs should see a category" do

    # Add a translated doc to the category
    I18n.locale = :et
    @doc = Doc.where(category_id: 1).first
    @doc.title = "Doc in Estonian"
    @doc.save

    get :index, locale: :et

    #Should not be a category box
    assert_select "div.topic-box", true
  end

  test "a browsing user should not see common replies on the home page even if they are featured" do
    AppSettings['theme.active'] = 'flat'
    get :index, locale: :en

    #Should not be any category boxes
    assert_select "#category-5", false
  end

  # Theme tests, since there is no theme controller and this logic should exist helper_method

  test "a browsing user should see the designated theme" do
    # Set theme
    AppSettings['theme.active'] = 'flat'

    get :index, locale: :en
    assert_template layout: 'flat'
  end

  test "a browsing user should see the default theme if no theme is designated" do
    # Set no theme
    AppSettings['theme.active'] = ''

    get :index, locale: :en
    assert_template layout: 'helpy'
  end

  test "a browsing user should see the theme passed in the url" do
    # Set no theme
    AppSettings['theme.active'] = 'helpy'

    get :index, locale: :en, theme: 'flat'
    assert_template layout: 'flat'
  end

  test "a browsing user should not get the get-help section if forums and tickets are disabled" do
    AppSettings['settings.forums'] = "0"
    AppSettings['settings.tickets'] = "0"
    get :index, locale: :en
    assert_select 'div#get-help-wrapper', false
  end

  test "a browsing user should get the get-help section if tickets are disabled" do
    AppSettings['settings.tickets'] = "0"
    get :index, locale: :en
    assert_select 'div#get-help-wrapper', true
  end

  test "a browsing user should get the get-help section if forums are disabled" do
    AppSettings['settings.forums'] = "0"
    get :index, locale: :en
    assert_select 'div#get-help-wrapper', true
  end

end
