require 'test_helper'

class KeyValueTest < ActiveSupport::TestCase

  test "deleting a topic with kvs should delete them too" do
    topic = Topic.create!(user_id: 1, name: 'test topic', forum_id: 1, private: false)
    topic.key_values.create!(key: 'one', value: 'two')

    assert_difference 'KeyValue.all.count', -1 do
      topic.destroy!
    end
  end

end
