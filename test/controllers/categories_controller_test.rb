# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  setup do
    # reset the available_locales before each test because on tests where
    # this is reduced, it persists and breaks other tests
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  test "a browsing user in the default locale should be able to load the index and see categories" do
    get :index, locale: :en
    assert_response :success

    # Should see at least once category
    assert_select 'a#category-1', true

    # should be able to see Documents
    assert_select 'li.article', true

  end

  test "a browsing user in a locale without translations should be able to load the index and see no categories" do
    get :index, locale: :fr
    assert_response :success

    # Make sure nothing here message shown
    assert_select 'div.nothing-in-locale', true

  end

  test "a browsing user in the default locale should be able to see a category page" do
    get :show, id: 1, locale: :en
    assert_response :success

    # should be able to see Documents
    assert_select 'li.article', true

  end

  # logged out, should not get these pages

  test "a browsing user should not be able to load new" do
    get :new, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load edit" do
    get :edit, { id: 1, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load create" do
    post :create, category: {name: "some name" }, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load update" do
    patch :update, { id: 1, category: { name: "some name" }, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load destroy" do
    delete :destroy, { id: 1, locale: :en }
    assert_redirected_to new_user_session_path
  end

  # logged in user, should not get these pages

  test "a signed in user should be able to load get new" do
    sign_in users(:user)
    get :new, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load edit" do
    sign_in users(:user)
    get :edit, { id: 1, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load create" do
    sign_in users(:user)
    post :create, category: {name: "some name"}, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load update" do
    sign_in users(:user)
    patch :update, { id: 1, category: { name: "some name" }, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load destroy" do
    sign_in users(:user)
    delete :destroy, { id: 1, locale: :en}
    assert_redirected_to root_path
  end



  #admin logged in, should get these pages

  test "an admin should be able to load new" do
    sign_in users(:admin)
    get :new, locale: :en
    assert_response :success
  end

  test "an admin should be able to edit a category" do
    sign_in users(:admin)
    get :edit, id: 1, locale: :en
    assert_response :success
  end

  test "an admin should see a translate dropdown when there are multiple available_locales" do
    sign_in users(:admin)
    get :edit, id: 1, locale: :en
    assert_select 'select#lang', 1
  end

  test "an admin should not see a translate dropdown when there is only one available_locale" do
    sign_in users(:admin)
    I18n.available_locales = [:en]
    get :edit, id: 1, locale: :en do
      assert_select 'select#lang', 0
    end
  end

  test "an admin should be able to create a new category" do
    sign_in users(:admin)
    assert_difference 'Category.count', 1 do
      post :create, category: { name: "some name" }, locale: :en
    end
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to create a new category, and have the default translation created" do
    sign_in users(:admin)
    post :create, category: { name: "some name" }, locale: :en
    assert_equal Category.last.translations.count, 1
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to update an existing category" do
    sign_in users(:admin)
    patch :update, { id: 1, category: {name: "some name" }, locale: :en }
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to add a new translation to an existing category" do
    sign_in users(:admin)
    assert_difference 'Category.find(1).translations.count', 1 do
      patch :update, { id: 1, category: {name: "some name" }, locale: :fr, lang: 'fr' }
    end
    assert_equal Category.find(1).translations.last.locale, :fr
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to destroy a category" do
    sign_in users(:admin)
    assert_difference 'Category.count', -1 do
      xhr :delete, :destroy, id: 1, locale: :en
    end
    assert_response :success
  end

end
