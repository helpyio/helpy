require 'integration_test_helper'
include Warden::Test::Helpers

class AdminSettingsFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    set_default_settings
    sign_in('admin@test.com')
    sleep(2)
  end

  def teardown
    Capybara.reset_sessions!
    Warden.test_reset!
  end

  test 'an admin should be able to modify site settings and see those changes on the support site' do
    visit('/admin/settings/general')
    assert page.has_content?('Settings'), 'Missing header'

    # Now make changes to all settings from defaults and make sure those changes are on the live site
    fill_in('settings.site_name', with: 'xyz')
    fill_in('settings.parent_site', with: 'xyz')
    fill_in('settings.parent_company', with: 'xyz')
    click_on 'Save Settings'

    visit('/en')
    sleep(1)
    within('a.navbar-brand') do
      assert page.has_content?('xyz')
    end
    assert page.has_content?('Back to xyz')

    # TODO: Figure out how to test the change of GA token
  end

  test 'Should be able to put a valid URL' do
    visit('/admin/settings/general')

    current_value = 'http://www.domain.com/helpy'
    fill_in('settings.site_url', with: current_value)
    click_on 'Save Settings'

    find("input[value='#{current_value}']")
  end

  test 'Should be able to put a URL with subdomain' do
    visit('/admin/settings/general')

    current_value = 'http://subdomain.domain.com/helpy'
    fill_in('settings.site_url', with: current_value)
    click_on 'Save Settings'

    find("input[value='#{current_value}']")
  end

  test 'Should be able to put a URL with multiple subdomains' do
    visit('/admin/settings/general')

    current_value = 'http://subdomain1.subdomain2.domain.com/helpy'
    fill_in('settings.site_url', with: current_value)
    click_on 'Save Settings'

    find("input[value='#{current_value}']")
  end

  test 'Should be able to put a URL with ip' do
    visit('/admin/settings/general')

    current_value = 'http://127.0.0.1/helpy'
    fill_in('settings.site_url', with: current_value)
    click_on 'Save Settings'

    find("input[value='#{current_value}']")
  end

  test 'an admin should be able to enable or disable i18n and be able to browse to those locales on the site' do
    visit('/admin/settings/i18n')

    assert page.has_content?('Settings'), 'Missing header'

    # Now make changes to all settings from defaults and make sure those changes are on the live site
    check('English')
    check('Español')
    check('Deutsch')
    click_on 'Save Settings'

    visit('/en/locales/select')
    sleep(1)

    # TODO: Need javascript for dropdown, currently using locale page

    within('ul.locale-list') do
      assert page.has_content?('English')
      assert page.has_content?('Español')
      assert page.has_content?('Deutsch')
      assert page.has_no_content?('eesti')
    end
  end

  test 'an admin should be able to alter the logo images used' do
    visit('/admin/settings/design')

    assert page.has_content?('Design'), 'Missing header'

    fill_in('design.header_logo', with: '/uploads/logos/logo-test.png')
    fill_in('design.favicon', with: '/uploads/logos/favicon-test.ico')
    click_on 'Save Settings'

    visit('/en')
    sleep(1)

    within('a.navbar-brand') do
      assert_equal '/uploads/logos/logo-test.png', page.find('img')['src']
    end

    # TODO: Figure out how to test the change of favicon
  end
end
