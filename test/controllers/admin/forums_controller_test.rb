# == Schema Information
#
# Table name: forums
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  topics_count       :integer          default(0), not null
#  last_post_date     :datetime
#  last_post_id       :integer
#  private            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  allow_topic_voting :boolean          default(FALSE)
#  allow_post_voting  :boolean          default(FALSE)
#  layout             :string           default("table")
#

require 'test_helper'

class Admin::ForumsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  # logged out, should not get these pages

  test "a browsing user should not get new" do
    get :new, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get edit" do
    get :edit, { id: 3, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get create" do
    post :create, forum: {name: "some name", description: "some descrpition"}, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get update" do
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"}, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get destroy" do
    delete :destroy, { id: 3, locale: :en }
    assert_redirected_to new_user_session_path
  end

  # logged in as user, should not get these pages
  %w(user editor).each do |unauthorized|
    test "a #{unauthorized} should not get new" do
      sign_in users(unauthorized.to_sym)
      get :new, locale: :en
      assert_redirected_to admin_root_path
    end

    test "a #{unauthorized} should not get edit" do
      sign_in users(unauthorized.to_sym)
      get :edit, { id: 3, locale: :en }
      assert_redirected_to admin_root_path
    end

    test "a #{unauthorized} should not get create" do
      sign_in users(unauthorized.to_sym)
      post :create, forum: {name: "some name", description: "some descrpition"}, locale: :en
      assert_redirected_to admin_root_path
    end

    test "a #{unauthorized} should not get update" do
      sign_in users(unauthorized.to_sym)
      patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"}, locale: :en }
      assert_redirected_to admin_root_path
    end

    test "a #{unauthorized} should not get destroy" do
      sign_in users(unauthorized.to_sym)
      delete :destroy, { id: 3, locale: :en }
      assert_redirected_to admin_root_path
    end
  end

  #logged in as admin, should get these pages
  %w(admin agent).each do |admin|
    test "an #{admin} should get new" do
      sign_in users(admin.to_sym)
      get :new, locale: :en
      assert_response :success
    end

    test "an #{admin} should get edit" do
      sign_in users(admin.to_sym)
      get :edit, id: 3, locale: :en
      assert_response :success
    end

    test "an #{admin} should get create" do
      sign_in users(admin.to_sym)
      post :create, forum: {name: "some name", description: "some descrpition"}, locale: :en
      assert_redirected_to admin_forums_path
    end

    test "an #{admin} should get update" do
      sign_in users(admin.to_sym)
      patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"}, locale: :en }
      assert_redirected_to admin_forums_path
    end

    test "an #{admin} should get destroy" do
      sign_in users(admin.to_sym)
      xhr :delete, :destroy, id: 3, locale: :en
      assert_template 'destroy'
    end
  end

end
