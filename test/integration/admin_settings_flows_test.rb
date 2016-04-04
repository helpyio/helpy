require 'integration_test_helper'
include Warden::Test::Helpers

class AdminSettingsFlowsTest < ActionDispatch::IntegrationTest

  def setup
    Warden.test_mode!
    I18n.available_locales = [:en, :es, :de, :fr, :et, :ca, :ru, :ja, 'zh-cn', 'zh-tw', 'pt', :nl]
    I18n.locale = :en

    sign_in('admin@test.com')
  end

  def teardown
    reset_default_settings
    Warden.test_reset!
  end

  def reset_default_settings
    AppSettings['settings.parent_site'] = Settings.parent_site
    AppSettings['settings.parent_company'] = Settings.parent_company
    AppSettings['settings.site_url'] = Settings.site_url
    AppSettings['settings.site_name'] = Settings.site_name
    AppSettings['settings.site_tagline'] = Settings.site_tagline
    AppSettings['settings.product_name'] = Settings.product_name
    AppSettings['settings.support_phone'] = Settings.support_phone
    AppSettings['settings.google_analytics_id'] = Settings.google_analytics_id
    AppSettings['design.favicon'] = Settings.app_favicon
    AppSettings['design.header_logo'] = Settings.app_mini_logo
    AppSettings['design.footer_mini_logo'] = Settings.app_large_logo
    AppSettings['css.search_background'] = 'feffe9'
    AppSettings['css.top_bar'] = '3cceff'
    AppSettings['css.link_color'] = '004084'
    AppSettings['css.form_background'] = 'F0FFF0'
    AppSettings['css.still_need_help'] = 'ffdf91'
    AppSettings['i18n.default_locale'] = 'en'
    AppSettings['i18n.available_locales'] = ''.split(',')
    AppSettings['widget.show_on_support_site'] = 'true'
  end


  test "an admin should be able to modify site settings and see those changes on the support site" do

    click_on 'Settings'
    assert page.has_content?("General Settings")

    # Now make changes to all settings from defaults and make sure those changes are on the live site
    fill_in('settings.site_name', with: 'xyz')
    fill_in('settings.parent_site', with: 'xyz')
    fill_in('settings.parent_company', with: 'xyz')
    fill_in('settings.google_analytics_id', with: 'xyz')
    click_on 'Save Settings'

    visit('/en')
    within('a.navbar-brand') do
      assert page.has_content?('xyz')
    end
    assert page.has_content?('Back to xyz')

    #TODO: Figure out how to test the change of GA token
  end

  test "an admin should be able to enable or disable i18n and be able to browse to those locales on the site" do

    click_on 'Settings'
    assert page.has_content?("General Settings")

    # Now make changes to all settings from defaults and make sure those changes are on the live site
    check('English')
    check('Español')
    check('Deutsch')
    click_on 'Save Settings'

    visit('/en/locales/select')

    # TODO: Need javascript for dropdown

    within('ul.locale-list') do
      assert page.has_content?('English')
      assert page.has_content?('Español')
      assert page.has_content?('Deutsch')
      assert page.has_no_content?('Eesti')
    end
  end

  test "an admin should be able to alter the logo images used" do

    click_on 'Settings'
    assert page.has_content?("Design")

    fill_in("Header Logo", with: 'logo-test.png')
    fill_in("Footer Logo", with: 'logo-test.png')
    fill_in("Favicon", with: 'favicon-test.png')
    click_on 'Save Settings'

    visit('/en')

    within('a.navbar-brand') do
      assert_equal '/images/logo-test.png', page.find('img')['src']
    end

    within('div#footer') do
      assert_equal '/images/logo-test.png', page.find('img')['src']
    end

    #TODO: Figure out how to test the change of favicon

  end


end
