require 'test_helper'

class RegistrationsControllerTest < ActionController::TestCase

  setup do
    @request.env["devise.mapping"] = Devise.mappings[:user]
    set_default_settings
  end

  test "a logged in user should be able to edit their user profile" do
    sign_in users(:user)
    get :edit, locale: :en

    assert_response :success
  end

  test "a logged in user should be able to update their user profile" do
    @user = users(:user)
    sign_in @user
    assert_difference "User.find(2).name.length", -3 do
      patch :update, { id: @user.id, user: {name: "something", current_password: "12345678"}, locale: :en }
      assert User.find(2).name == "something", "name does not update"
    end
    assert_redirected_to root_path
  end

  test "a user should be able to add a profile image to their profile" do
    @user = users(:user)
    sign_in @user

    assert_difference "User.find(2).name.length", -3 do
      patch :update, {
        id: @user.id,
        user: {
          name: "something",
          profile_image: uploaded_file_object(User, :profile_image, file),
          current_password: "12345678"
        },
        locale: :en }
    end
    #binding.pry
    assert_equal "logo.png", User.find(2).profile_image.file.file.split("/").last
    assert User.find(2).name == "something", "name does not update"
    assert_redirected_to root_path
  end

  test "an omniauth logged in user should be able to update their user profile without password" do
    @user = users(:oauth_user)
    sign_in @user
    assert_difference "User.find(4).name.length", -3 do
      patch :update, { id: @user.id, user: {name: "something"}, locale: :en }
      assert User.find(4).name == "something", "name does not update"
    end
    assert_redirected_to root_path
  end

  test "a signed in user should NOT be able to change their admin or active status" do
    sign_in users(:user)

    patch :update, { id: 2, user: {role: 'admin', current_password: "12345678"}, locale: :en }
    assert users(:user).is_admin? == false

    assert_redirected_to root_path

  end

end
