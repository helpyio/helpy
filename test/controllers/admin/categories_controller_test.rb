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

class Admin::CategoriesControllerTest < ActionController::TestCase

  setup do
    set_default_settings
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
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load edit" do
    sign_in users(:user)
    get :edit, { id: 1, locale: :en }
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load create" do
    sign_in users(:user)
    post :create, category: {name: "some name"}, locale: :en
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load update" do
    sign_in users(:user)
    patch :update, { id: 1, category: { name: "some name" }, locale: :en }
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load destroy" do
    sign_in users(:user)
    delete :destroy, { id: 1, locale: :en}
    assert_redirected_to admin_root_path
  end

  # admin logged in, should get these pages
  %w(admin agent editor).each do |admin|

    test "an #{admin} should be able to access the index and get the featured categories" do
      sign_in users(admin.to_sym)
      get :index, locale: :en
      assert_response :success
    end

    test "an #{admin} should be able to get the details of a particular featured category" do
      sign_in users(admin.to_sym)
      get :show, locale: :en, id: 1
      assert_response :success
    end

    test "an #{admin} should be able to load new" do
      sign_in users(admin.to_sym)
      get :new, locale: :en
      assert_response :success
    end

    test "an #{admin} should be able to edit a category" do
      sign_in users(admin.to_sym)
      get :edit, id: 1, locale: :en
      assert_response :success
    end

    test "an #{admin} should see a translate dropdown when there are multiple available_locales" do
      sign_in users(admin.to_sym)

      # Ensure there are multiple locales
      AppSettings["i18n.available_locales"] = %w(en es fr)

      get :edit, id: 1, locale: "en"
      assert_select "select#lang", 1
    end

    test "an #{admin} should not see a translate dropdown when there is only one available_locale" do
      sign_in users(admin.to_sym)

      AppSettings["i18n.available_locales"] = ["en"]
      get :edit, id: 1, locale: :en do
        assert_select "select#lang", 0
      end
    end

    test "an #{admin} should be able to create a new category" do
      sign_in users(admin.to_sym)
      assert_difference "Category.count", 1 do
        post :create, category: { name: "some name" }, locale: :en
      end
      assert_redirected_to admin_categories_path
    end

    test "an #{admin} creating a category with no name re-renders the new template" do
      sign_in users(admin.to_sym)
      assert_difference "Category.count", 0 do
        post :create, category: { name: nil }, locale: :en
      end
      assert_template :new
    end

    test "an #{admin} should be able to create a new category, and have the default translation created" do
      sign_in users(admin.to_sym)
      post :create, category: { name: "some name" }, locale: :en
      assert_equal Category.last.translations.count, 1
      assert_redirected_to admin_categories_path
    end

    test "an #{admin} should be able to update an existing category" do
      sign_in users(admin.to_sym)
      patch :update, { id: 1, category: {name: "some name" }, locale: :en }
      assert_redirected_to admin_categories_path
    end

    test "an #{admin} attempting to update a category with invalid params re-renders the edit template" do
      sign_in users(admin.to_sym)
      patch :update, { id: 1, category: {name: nil }, locale: :en }
      assert_template :edit
    end

    test "an #{admin} should be able to add a new translation to an existing category" do
      sign_in users(admin.to_sym)
      assert_difference "Category.find(1).translations.count", 1 do
        patch :update, { id: 1, category: {name: "some name" }, locale: :fr, lang: "fr" }
      end
    end

    test "an #{admin} should be able to destroy a category" do
      sign_in users(admin.to_sym)
      assert_difference "Category.count", -1 do
        xhr :delete, :destroy, id: 1, locale: :en
      end
      assert_response :success
    end

  end

end
