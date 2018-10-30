require 'integration_test_helper'

include Warden::Test::Helpers

class ClientSideValidationForGroupNewFormTest < ActionDispatch::IntegrationTest
  def setup
    Capybara.current_driver = :chrome
    Warden.test_mode!
    set_default_settings
    sign_in('admin@test.com')
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
    Capybara.use_default_driver
  end
  
  test 'browsing will throw a error if user input with nil value on new form group' do
    visit '/admin/settings/groups/new'
    fill_in('acts_as_taggable_on_tag[name]',  with: '')
    click_on 'Save Settings'
    assert page.has_content?("can't be blank")
  end
end
