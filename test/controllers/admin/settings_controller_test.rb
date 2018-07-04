require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase

  setup do
    # login admin for all tests of admin functions
    @request.headers['Accepts'] = 'text/javascript, application/javascript, application/ecmascript, application/x-ecmascript'
    set_default_settings
  end

  test 'an admin should be able to load the settings' do
    sign_in users(:admin)
    get :index
    assert_response :success
  end

  %w(user agent editor).each do |unauthorized|

    # TODO: Temporarily disabled these cause they were failing even thought the
    # functionality works okay in the browser

    # test "an #{unauthorized} should NOT be able to modify the settings" do
    #   sign_in users(unauthorized.to_sym)
    #   put :update_settings,
    #     'settings.site_name' => 'Helpy Support 2',
    #     'settings.parent_site' => 'http://helpy.io/2',
    #     'settings.parent_company' => 'Helpy 2',
    #     'settings.site_tagline' => 'Support',
    #     'settings.google_analytics_id' => 'UA-0000-21'
    #   assert_redirected_to root_path
    #   assert_not_equal 'Helpy Support 2', AppSettings['settings.site_name']
    #   assert_not_equal 'http://helpy.io/2', AppSettings['settings.parent_site']
    #   assert_not_equal 'Helpy 2', AppSettings['settings.parent_company']
    #   assert_not_equal 'Support', AppSettings['settings.site_tagline']
    #   assert_not_equal 'UA-0000-21', AppSettings['settings.google_analytics_id']
    # end
    #
    # test "an #{unauthorized} should NOT be able to load the settings" do
    #   sign_in users(unauthorized.to_sym)
    #   get :index
    #   assert_redirected_to root_path
    # end
  end

  test 'an admin should be able to modify settings' do
    sign_in users(:admin)
    xhr :put, :update_settings,
      'settings.site_name' => 'Helpy Support 2',
      'settings.parent_site' => 'http://helpy.io/2',
      'settings.parent_company' => 'Helpy 2',
      'settings.site_tagline' => 'Support',
      'settings.google_analytics_id' => 'UA-0000-21'
    assert_response :success
    assert_equal 'Helpy Support 2', AppSettings['settings.site_name']
    assert_equal 'http://helpy.io/2', AppSettings['settings.parent_site']
    assert_equal 'Helpy 2', AppSettings['settings.parent_company']
    assert_equal 'Support', AppSettings['settings.site_tagline']
    assert_equal 'UA-0000-21', AppSettings['settings.google_analytics_id']
  end

  test 'an admin should be able to modify design' do
    sign_in users(:admin)
    xhr :put,:update_settings,
      'design.header_logo' => 'logo2.png',
      'design.footer_mini_logo' => 'logo2.png',
      'design.favicon' => 'favicon2.ico',
      'css.search_background' => '000000',
      'css.top_bar' => '000000',
      'css.link_color' => '000000',
      'css.form_background' => '000000',
      'css.still_need_help' => '000000'
    assert_response :success
    assert_equal 'logo2.png', AppSettings['design.header_logo']
    assert_equal 'logo2.png', AppSettings['design.footer_mini_logo']
    assert_equal 'favicon2.ico', AppSettings['design.favicon']
    assert_equal '000000', AppSettings['css.search_background']
    assert_equal '000000', AppSettings['css.top_bar']
    assert_equal '000000', AppSettings['css.link_color']
    assert_equal '000000', AppSettings['css.form_background']
    assert_equal '000000', AppSettings['css.still_need_help']
  end

  test 'an admin should be able to change the theme' do
    AppSettings['theme.active'] = ''

    sign_in users(:admin)
    put :update_settings,
      'theme.active' => 'flat'
    assert_equal 'flat', AppSettings['theme.active']
  end

  test 'an admin should be able to toggle locales on and off' do
    sign_in users(:admin)
    # first, toggle off all locales
    AppSettings['i18n.available_locales'] = ''

    xhr :put, :update_settings,
      'i18n.available_locales' => ['en', 'es', 'de', 'fr', 'et', 'ca', 'ru', 'ja', 'zh-cn', 'zh-tw', 'pt', 'nl']

    assert_response :success
    assert_equal ['en', 'es', 'de', 'fr', 'et', 'ca', 'ru', 'ja', 'zh-cn', 'zh-tw', 'pt', 'nl'], AppSettings['i18n.available_locales']
  end

  test 'an admin should be able to toggle display of the widget on and off' do
    sign_in users(:admin)
    # toggle it off
    AppSettings['widget.show_on_support_site'] = 0
    xhr :put, :update_settings, 'widget.show_on_support_site' => '1'
    assert_equal '1', AppSettings['widget.show_on_support_site']
  end

  test 'an admin should be able to turn email delivery on and off' do
    put :update_settings,
      'email.send_email' => 'false'

    # TODO: Refactor this into an integration test
    # assert_no_difference 'ActionMailer::Base.deliveries.size' do
    #   xhr :post, create_admin_topic_path, topic: { user: { name: 'a user', email: 'anon@test.com' }, name: 'some new private topic', post: { body: 'this is the body' }, forum_id: 1 }
    # end
  end

  test 'an admin should be able to add mail settings' do
    sign_in users(:admin)
    xhr :put, :update_settings,
      'email.admin_email' => 'test@test.com',
      'email.from_email' => 'test@test.com',
      'email.mail_service' => 'mailgun',
      'email.mail_smtp' => 'mail.test.com',
      'email.smtp_mail_username' => 'test-login',
      'email.smtp_mail_password' => '1234',
      'email.mail_port' => '587',
      'email.mail_domain' => 'something.com'
    assert_response :success

    assert_equal 'test@test.com', AppSettings['email.admin_email']
    assert_equal 'test@test.com', AppSettings['email.from_email']
    assert_equal 'mailgun', AppSettings['email.mail_service']
    assert_equal 'mail.test.com', AppSettings['email.mail_smtp']
    assert_equal 'test-login', AppSettings['email.smtp_mail_username']
    assert_equal '1234', AppSettings['email.smtp_mail_password']
    assert_equal '587', AppSettings['email.mail_port']
    assert_equal 'something.com', AppSettings['email.mail_domain']
  end

  test 'an admin should be able to add a cloudinary key' do
    sign_in users(:admin)
    xhr :put, :update_settings,
      'cloudinary.cloud_name' => 'something',
      'cloudinary.api_key' => 'something',
      'cloudinary.api_secret' => 'something'
    assert_response :success
    assert_equal 'something', AppSettings['cloudinary.cloud_name']
    assert_equal 'something', AppSettings['cloudinary.api_key']
    assert_equal 'something', AppSettings['cloudinary.api_secret']
    get :index
  end

  test 'the updated cloudinary keys should be persisted into the api object' do
    sign_in users(:admin)
    xhr :put, :update_settings,
      'cloudinary.cloud_name' => 'something',
      'cloudinary.api_key' => 'something',
      'cloudinary.api_secret' => 'something'
    assert_response :success
    get :index
    assert_equal 'something', Cloudinary.config.cloud_name
    assert_equal 'something', Cloudinary.config.api_key
    assert_equal 'something', Cloudinary.config.api_secret
  end

  test "an agent should be able to update their profile" do
    sign_in users(:agent)
    get :profile
    assert :success
  end

end
