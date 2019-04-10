require 'test_helper'

class UserMailerTest < ActionMailer::TestCase

  setup do
    set_default_settings
    AppSettings['settings.welcome_email'] = '0'
  end

  test 'No mail sent if setting disabled' do
    user = users(:user)
    email = UserMailer.new_user(user.id, 'token')

    assert_emails 0 do
      email.deliver_now
    end
  end
end
