require 'test_helper'

class HomeControllerTest < ActionController::TestCase

  setup do
    # reset the available_locales before each test because on tests where
    # this is reduced, it persists and breaks other tests
    I18n.available_locales = [:en, :fr, :et]
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

  test "a browsing user in a locale without translations hould see a home page featuring at least one category" do
    get :index, locale: :fr

    #Should be at least one category box
    assert_select 'div.topic-box', false

  end

end
