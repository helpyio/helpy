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
    assert_redirected_to admin_root_path
  end

  test "a signed in user should not be able to load the group page" do
    sign_in users(:user)
    get :index, locale: :en
    assert_redirected_to admin_root_path
  end

  test "an admin should be able to load the group page" do
    sign_in users(:admin)
    get :index, locale: :en
    assert_response :success
  end

  test "an admin should be able to create new group with dummy tagging" do
    sign_in users(:admin)
    params = {acts_as_taggable_on_tag: {name: "test_tag", show_on_helpcenter: true, show_on_admin: true, show_on_dashboard: true}}
    assert_difference "ActsAsTaggableOn::Tag.count", 1 do
      post :create, params
    end
  end

  test "an admin should be able to delete group" do
    sign_in users(:admin)
    tag = create(:acts_as_taggable_on_tag)
    assert_difference "ActsAsTaggableOn::Tag.count", -1 do
      delete :destroy, { id: tag.id, locale: "en" }
    end
  end

  test "an admin should be able to update group" do
    sign_in users(:admin)
    tag = create(:acts_as_taggable_on_tag)
    put :update, { id: tag.id, acts_as_taggable_on_tag: {show_on_admin: true}}
    assert_equal ActsAsTaggableOn::Tag.last.show_on_admin, true
  end

end
