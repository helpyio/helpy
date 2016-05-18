require 'test_helper'

class Admin::SharedControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:admin)
  end

  test 'an admin should be able to reorder docs' do
    post :update_order, object: 'doc', obj_id: 4, row_order_position: 0
    assert_equal 4, Doc.order('rank asc').first.id
  end

  test 'an admin should be able to reorder categories' do
    post :update_order, object: 'category', obj_id: 4, row_order_position: 0
    assert_equal 4, Category.order('rank asc').first.id
  end

end
