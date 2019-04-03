require 'integration_test_helper'
include Warden::Test::Helpers
include Capybara::Email::DSL

class ResetPasswordTest < ActionDispatch::IntegrationTest

  setup do
    clear_emails
    Warden.test_mode!
    set_default_settings
    OmniAuth.config.test_mode = true
    @user = User.find(9)
  end

  teardown do
    OmniAuth.config.test_mode = false
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test "should prevent a bad token from resetting the password" do

    old_password = @user.encrypted_password
    visit('/en/users/password/edit?reset_password_token=bad-token')
    within(".simple_form") do
      fill_in('New password', with: "new-password")
      fill_in('Confirm new password', with: "new-password")
    
      click_on('Change my password')
    end
    assert_equal @user.encrypted_password, old_password
  end

  test "reset user's password" do 
    old_password = @user.encrypted_password

    # check to ensure mailer sends reset password email
    assert_difference('ActionMailer::Base.deliveries.count', 1) do
      post user_password_path, user: {email: @user.email}
      assert_redirected_to new_user_session_path
    end

    open_email(@user.email)
    current_email.click_link 'Change my password'

    assert page.has_content? 'Change my password'
    within(".simple_form") do
      fill_in('New password', with: "new-password")
      fill_in('Confirm new password', with: "new-password")
    
      click_on('Change my password')
    end

    @user.reload
    assert_not_equal(@user.encrypted_password, old_password)
  end
end