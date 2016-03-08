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

class ForumsControllerTest < ActionController::TestCase

  setup do
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  test "a browsing user should get index" do
    get :index, locale: :en
    assert_response :success
    assert_equal(3, assigns(:forums).count)

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

  test "a signed in user should not get new" do
    sign_in users(:user)
    get :new, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not get edit" do
    sign_in users(:user)
    get :edit, { id: 3, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not get create" do
    sign_in users(:user)
    post :create, forum: {name: "some name", description: "some descrpition"}, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not get update" do
    sign_in users(:user)
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"}, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not get destroy" do
    sign_in users(:user)
    delete :destroy, { id: 3, locale: :en }
    assert_redirected_to root_path
  end



  #logged in as admin, should get these pages

  test "an admin should get new" do
    sign_in users(:admin)
    get :new, locale: :en
    assert_response :success
  end

  test "an admin should get edit" do
    sign_in users(:admin)
    get :edit, id: 3, locale: :en
    assert_response :success
  end

  test "an admin should get create" do
    sign_in users(:admin)
    post :create, forum: {name: "some name", description: "some descrpition"}, locale: :en
    assert_redirected_to admin_communities_path
  end

  test "an admin should get update" do
    sign_in users(:admin)
    patch :update, { id: 3, forum: {name: "some name", description: "some descrpition"}, locale: :en }
    assert_redirected_to admin_communities_path
  end

  test "an admin should get destroy" do
    sign_in users(:admin)
    delete :destroy, id: 3, locale: :en
    assert_redirected_to admin_communities_path
  end

end
