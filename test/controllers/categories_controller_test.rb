require 'test_helper'

class CategoriesControllerTest < ActionController::TestCase

  test "a browsing user should get index" do
    get :index, locale: :en
    assert_response :success
  end

  test "a browsing user should get show" do
    get :show, id: 1, locale: :en
    assert_response :success
  end

  # logged out, should not get these pages

  test "a browsing user should not get new" do
    get :new, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get edit" do
    get :edit, { id: 1, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get create" do
    post :create, category: {name: "some name" }, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get update" do
    patch :update, { id: 1, category: { name: "some name" }, locale: :en }
    assert_redirected_to new_user_session_path
  end

  test "a browsing user should not get destroy" do
    delete :destroy, { id: 1, locale: :en }
    assert_redirected_to new_user_session_path
  end

  # logged in user, should not get these pages

  test "a signed in user should not get new" do
    sign_in users(:user)
    get :new, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not get edit" do
    sign_in users(:user)
    get :edit, { id: 1, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not get create" do
    sign_in users(:user)
    post :create, category: {name: "some name"}, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not get update" do
    sign_in users(:user)
    patch :update, { id: 1, category: { name: "some name" }, locale: :en }
    assert_redirected_to root_path
  end

  test "a signed in user should not get destroy" do
    sign_in users(:user)
    delete :destroy, { id: 1, locale: :en}
    assert_redirected_to root_path
  end



  #admin logged in, should get these pages

  test "an admin should get new" do
    sign_in users(:admin)
    get :new, locale: :en
    assert_response :success
  end

  test "an admin should get edit" do
    sign_in users(:admin)
    get :edit, id: 1, locale: :en
    assert_response :success
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
    assert_equal Category.last.translations.count, 2
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to update an existing category" do
    sign_in users(:admin)
    patch :update, { id: 1, category: {name: "some name" }, locale: :en }
    assert_redirected_to admin_knowledgebase_path
  end

  test "an admin should be able to add a new translation to an existing category" do
    sign_in users(:admin)
    assert_equal Category.find(1).translations.count, 2 do
      patch :update, { id: 1, category: {name: "some name" }, locale: :en, lang: 'fr' }
    end
    assert_equal Category.find(1).translations.last.locale, :en
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
