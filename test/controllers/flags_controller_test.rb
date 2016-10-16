require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  setup do
    set_default_settings
  end

  test "a signed user should be able to flag post for review" do
    sign_in users(:user)

    assert_difference 'Flag.count', 1, 'A flag should have been created' do
      xhr :post, :create, topic_id: 4, flag: { reason: 'test' }, locale: :en
    end
  end

  test "a flagged post should create a new private topic" do
    sign_in users(:user)

    assert_difference "Topic.where('name like ?', 'Flagged%').count", 1, 'A new topic should be created' do 
      xhr :post, :create, topic_id: 4, flag: { reason: 'test' }, locale: :en
    end
  end
end
