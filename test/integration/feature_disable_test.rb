require 'integration_test_helper'

include Warden::Test::Helpers

class FeatureDisableTest < ActionDispatch::IntegrationTest
  def setup
    Warden.test_mode!
    set_default_settings
    sign_in('system@test.com')
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test 'the page will redirect to root_path when the forums are disabled' do
    AppSettings['settings.forums'] = "0"
    visit '/en/community/'
    assert_equal root_path, current_path
  end

  test 'the page will redirect to root_path when the knowledgebase is disabled' do
    AppSettings['settings.knowledgebase'] = "0"
    visit '/en/knowledgebase/'
    assert_equal root_path, current_path
  end

  test 'the page will redirect to root_path when the tickets or forums are disabled' do
    AppSettings['settings.tickets'] = "0" 
    AppSettings['settings.forums'] = '0'
    visit '/en/topics/new'
    assert_equal root_path, current_path
  end
end