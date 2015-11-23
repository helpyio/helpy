require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    # reset the available_locales before each test because on tests where
    # this is reduced, it persists and breaks other tests
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
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
    assert_equal I18n.available_locales.count, 3 do
      assert_select 'span.select-locale', true
    end
  end

  test "a browsing user should not see a selector for locale if there are no alternate locales" do
    get :index, locale: :en
    I18n.available_locales = [:en]
    assert_equal I18n.available_locales.count, 1, "The available locales are #{I18n.available_locales}" do
      assert_select 'span.select-locale', false, "Should not have found locale selector"
    end
  end

  test "a browsing user should see the correct template when visiting the home page" do
    get :index, locale: :en
    assert_template layout: "layouts/application"
  end

  # There are two categories in the test data, one is featured on home page
  test "a browsing user in the default locale should see a home page featuring at least one category" do
    get :index, locale: :en
    assert_not_nil assigns(:categories)

    #Should be at least one category box
    assert_select 'div.topic-box', true

  end

  # If there are no translations for a given locale, no category boxes should be displayed
  test "a browsing user in a locale without translations should not see any category" do
    get :index, locale: :fr

    #Should not be any category boxes
    assert_select 'div.topic-box', false
  end

  # Even if there is a translated category for the current locale, if there are no translated docs in that category,
  # No category boxes should be shown
  test "a browsing user in a locale with a translated category but without translated docs should not see any category" do
    get :index, locale: :et

    #Should not be any category boxes
    assert_select 'div.topic-box', false
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
    assert_select 'div.topic-box', true
  end

end
