# == Schema Information
#
# Table name: docs
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  category_id      :integer
#  user_id          :integer
#  active           :boolean          default(TRUE)
#  rank             :integer
#  permalink        :string
#  version          :integer
#  front_page       :boolean          default(FALSE)
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)
#

require 'test_helper'

class Admin::DocsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  # logged out, should not get these pages

  test "a browsing user should not be able to load new" do
    get :new, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load edit" do
    get :edit, { id: 3, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load create" do
    post :create, doc: { title: "some name", body: "some body text", category_id: 1 }, locale: "en"
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load update" do
    patch :update, { id: 1, doc: { title: "some name", body: "some body text", category_id: 1}, locale: "en" }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not be able to load destroy" do
    delete :destroy, { id: 3, locale: "en" }
    assert_redirected_to new_user_session_path
  end

  # logged in as user, should not get these pages

  test "a signed in user should not be able to load new" do
    sign_in users(:user)
    get :new, locale: :en
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load edit" do
    sign_in users(:user)
    get :edit, { id: 3, locale: :en}
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load create" do
    sign_in users(:user)
    assert_difference "Doc.count", 0 do
      post :create, doc: {title: "some name", body: "some body text", category_id: 1}, locale: :en
    end
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load update" do
    sign_in users(:user)
    patch :update, { id: 1, doc: {title: "some name", body: "some body text", category_id: 1}, locale: :en }
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load destroy" do
    sign_in users(:user)
    assert_difference "Doc.count", 0 do
      delete :destroy, { id: 3, locale: :en }
    end
    assert_redirected_to admin_root_path
  end

  # Admin actions
  %w(admin agent editor).each do |admin|

    test "an #{admin} should be able to load new" do
      sign_in users(admin.to_sym)
      get :new, locale: :en
      assert_response :success
    end

    test "an #{admin} should be able to edit a doc" do
      sign_in users(admin.to_sym)
      get :edit, id: 1, category_id: 1, locale: :en
      assert_response :success
    end

    test "an #{admin} should see a translate dropdown when there are multiple available_locales" do
      sign_in users(admin.to_sym)
      AppSettings["i18n.available_locales"] = %w(en es fr)
      get :edit, id: 1, category_id: 1, locale: "en"
      assert_select "select#lang", 1
    end

    test "an #{admin} should not see a translate dropdown when there is only one available_locale" do
      sign_in users(admin.to_sym)
      AppSettings["i18n.available_locales"] = ["en"]
      get :edit, id: 1, category_id: 1, locale: :en do
        assert_select "select#lang", 0
      end
    end

    test "an #{admin} should be able to create a new doc" do
      sign_in users(admin.to_sym)
      assert_difference "Doc.count", 1 do
        post :create, doc: { title: "some name", body: "some body text", category_id: 1 }, locale: :en
      end
      assert_redirected_to admin_category_path(Doc.find(1).category.id)
    end

    # TODO: Need to move this test to Integration, because it crosses from admin into front-end views
    # test "an #{admin} should be able to create an article, then view that new article" do
    #   assert_difference "Doc.count", 1 do
    #     post :create, doc: { title: "some name", body: "some body text", category_id: 1 }, locale: :en
    #   end
    #   lastdoc =
    #   get :show, id: lastdoc, locale: :en
    #   assert_response :success
    # end

    test "an #{admin} should be able to update an article" do
      sign_in users(admin.to_sym)
      patch :update, { id: 1, doc: { title: "some name", body: "some body text", category_id: 1 }, locale: :en }
      assert_redirected_to admin_category_path(Doc.find(1).category.id)
    end

    test "an #{admin} should be able to create a new translation via the update page" do
      sign_in users(admin.to_sym)
      patch :update, { id: 1, doc: { title: "En Francais", body: "Ceci est la version française", category_id: 1 }, locale: :en, lang: :fr }
      assert_equal Doc.find(1).translations.count, 2
      assert_redirected_to admin_category_path(Doc.find(1).category.id)
    end

    # TODO: Need to move this test to Integration, because it crosses from admin into front-end views
    # test "an #{admin} should be able to create a new translation and then view it" do
    #   patch :update, { id: 1, doc: { title: "En Francais", body: "Ceci est la version française", category_id: 1 }, locale: :en, lang: :fr }
    #
    #   get :show, id: 1, locale: :fr
    #   assert_select "h1", "En Francais"
    #   assert_select "p", "Ceci est la version française"
    # end

    test "an #{admin} should be able to destroy a doc" do
      sign_in users(admin.to_sym)
      assert_difference "Doc.count", -1 do
        xhr :delete, :destroy, id: 1, locale: :en
      end
      assert_response :success
    end

    test "an #{admin} should see the option to attach files if cloudinary configured" do
      sign_in users(admin.to_sym)

      # Make sure cloudinary cloud name is setup
      AppSettings['cloudinary.enabled'] = "1"
      AppSettings['cloudinary.cloud_name'] = "test-cloud"
      AppSettings['cloudinary.api_key'] = "some-key"
      AppSettings['cloudinary.api_secret'] = "test-cloud"

      # Get new topics page
      sign_in users(:admin)
      get :new, locale: :en
      assert_response :success

      assert_select("input.cloudinary-fileupload", true)

    end

    test "an #{admin} should not see the option to attach files if cloudinary is not configured" do
      sign_in users(admin.to_sym)

      # Make sure cloudinary cloud name is setup
      AppSettings['cloudinary.enabled'] = "1"
      AppSettings['cloudinary.cloud_name'] = ""
      AppSettings['cloudinary.api_key'] = ""
      AppSettings['cloudinary.api_secret'] = ""

      # Get new topics page
      sign_in users(:admin)
      get :new, locale: :en
      assert_response :success

      assert_select("input.cloudinary-fileupload", false)
    end
  end
end
