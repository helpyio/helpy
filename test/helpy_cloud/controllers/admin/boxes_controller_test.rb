require 'test_helper'

class Admin::BoxesControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a signed out user should not be able to load the boxes page" do
    get :index, locale: :en
    assert_redirected_to new_user_session_path
  end

  test "a signed in user should not be able to load the boxes page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to root_path
  end

  test "an admin should be able to load the boxes page" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

  test "an admin should be able to create new boxes" do
    sign_in users(:admin)
    params = {box: {label: "priority", description: "priority users", user_priority_in: "['','VIP']"}}
    assert_difference "Box.count", +1 do
      post :create, params
    end
  end

  test "an admin should be able to delete boxes" do
    sign_in users(:admin)
    box = Box.create(label: 'test')
    assert_difference "Box.count", -1 do
      delete :destroy, { id: box.id, locale: "en" }
    end
  end

  test "an admin should be able to update boxes" do
    sign_in users(:admin)
    box = Box.create(label: 'test')
    put :update, { id: box.id, box: {label: "priority"}}
    assert_equal "priority", Box.last.label
  end

end
