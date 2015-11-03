require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  # browsers

  test "a browser should NOT be able to view edit profile page" do
    get :edit, id: 2, locale: :en
    assert_redirected_to new_user_session_path
  end

  # admins


  test "an admin should be able to update a user" do
    sign_in users(:admin)
    assert_difference('User.find(2).name.length',-3) do
      patch :update, { id: 2, user: {name: 'something', email:'scott.miller@test.com'}, locale: :en }
    end
    assert User.find(2).name == 'something', "name does not update"
  end

  test "an admin should be able to update a user and make them an admin" do
    sign_in users(:admin)
    assert_difference('User.admins.count',1) do
      patch :update, { id: 2, user: {name: 'something', email:'scott.miller@test.com', admin: true}, locale: :en }
    end
  end

end
