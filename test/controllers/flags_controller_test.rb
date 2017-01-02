# == Schema Information
#
# Table name: flags
#
#  id                 :integer          not null, primary key
#  post_id            :integer
#  generated_topic_id :integer
#  reason             :text
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#

require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  setup do
    set_default_settings
  end

  test "a signed user should be able to flag post for review" do
    sign_in users(:user)

    assert_difference 'Flag.count', 1, 'A flag should have been created' do
      xhr :post, :create, post_id: 7, flag: { reason: 'test' }, locale: :en
    end
  end

  test "a flagged post should create a new private topic" do
    sign_in users(:user)

    assert_difference "Topic.where('name like ?', 'Flagged%').count", 1, 'A new topic should be created' do 
      xhr :post, :create, post_id: 7, flag: { reason: 'test' }, locale: :en
    end
  end
end
