# == Schema Information
#
# Table name: tags
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class Admin::GroupsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a signed out user should not be able to load the group page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to root_path
  end

  test "a signed in user should not be able to load the group page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to root_path
  end

  test "an admin should be able to load the group page" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

end
