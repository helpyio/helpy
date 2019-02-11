# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  name         :string
#  date_expired :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'test_helper'

class Admin::ApiKeysControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a signed out user should not be able to load the api page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load the api page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to admin_root_path
  end

  test "an admin should be able to load the api key page" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

end
