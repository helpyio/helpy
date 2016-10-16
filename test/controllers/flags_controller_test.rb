require 'test_helper'

class FlagsControllerTest < ActionController::TestCase
  setup do
    set_default_settings
  end

  test "a signed user should be able to flag post for review" do
    sign_in users(:user)

    get :index, topic_id: 4, locale: :en
    assert_difference 'Flag.count', 1, 'A flag should have been created' do
      xhr :post, topic_id: 4, reason: 'test', locale: :en
    end
  end
end
