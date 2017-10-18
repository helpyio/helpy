require_relative '../../test_helper'

class Admin::InternalDocsControllerTest < ActionController::TestCase
  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test "showing active doc" do
    get :show, internal_category_id: 1, id: 1
    refute_nil assigns(:doc)
    assert_equal "Article 1", assigns(:page_title)
    assert_response :success
  end

  test "showing inactive doc" do
    get :show, internal_category_id: 1, id: 2
    assert_nil assigns(:doc)
    assert_response :redirect
  end
end
