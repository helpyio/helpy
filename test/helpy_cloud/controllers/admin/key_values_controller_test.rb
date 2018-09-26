require 'test_helper'

class Admin::KeyValuesControllerTest < ActionController::TestCase

  setup do
    set_default_settings
    sign_in users(:admin)

    @topic = Topic.first
  end

  test "Should be able to add a key value pair" do
    @topic = Topic.first

    assert_difference 'KeyValue.count', 1 do
      xhr :post, :create, key_value: { key: 'color', value: 'red', kvable_id: @topic.id, kvable_type: 'Topic' }
    end
  end

  test "Should be able to update a key value value" do
    @kv = KeyValue.create!(key: 'color', value: 'red', kvable_id: @topic.id, kvable_type: 'Topic')

    xhr :put, :update, id: @kv.id,  key_value: { value: 'blue' }
    assert_equal 'blue', KeyValue.last.value
  end

  test "Should be able to delete a key value" do
    @kv = KeyValue.create!(key: 'color', value: 'red', kvable_id: @topic.id, kvable_type: 'Topic')

    assert_difference 'KeyValue.count', -1 do
      xhr :delete, :destroy, id: @kv.id
    end
  end

end
