require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers['Accepts'] = 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'
    set_default_settings
  end

  test 'an admin should be able to modify protected settings' do
    sign_in users(:admin)
    put :update_general,
      'protect.helpcenter' => '1',
      'protect.block_web_signups' => '1'
    assert_equal '1', AppSettings['protect.helpcenter']
    assert_equal '1', AppSettings['protect.block_web_signups']
    assert_redirected_to admin_general_settings_path
  end
end
