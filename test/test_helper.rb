# Simplecov to give a report of the test coverage on local development environment
require 'simplecov'
SimpleCov.start

#require 'codeclimate-test-reporter'
#CodeClimate::TestReporter.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Requiring this library causes your jobs to run everything inline. So a call to the following
# will actually be SYNCHRONOUS
require 'sucker_punch/testing/inline'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  Settings.send_email = false
end

class ActionController::TestCase
  include Devise::TestHelpers
end

def set_default_settings
  # Enable i18n locales in Rails
  I18n.available_locales = [:en, :es, :de, :fr, :et, :ca, :ru, :ja, 'zh-cn', 'zh-tw', 'pt', :nl]
  I18n.locale = :en

  # Loads default settings
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
  AppSettings['i18n.available_locales'] = ['en', 'fr', 'de', 'et']
  AppSettings['widget.show_on_support_site'] = 'true'
  AppSettings['email.admin_email'] = Settings.admin_email
  AppSettings['email.from_email'] = Settings.from_email
  AppSettings['email.send_email'] = 'true'
  AppSettings['email.mail_service'] = Settings.mail_service
  AppSettings['email.smtp_mail_username'] = Settings.smtp_mail_username
  AppSettings['email.smtp_mail_password'] = Settings.smtp_mail_password
  AppSettings['email.mail_smtp'] = Settings.mail_smtp
  AppSettings['email.mail_port'] = Settings.mail_port
  AppSettings['email.mail_domain'] = Settings.mail_domain
  AppSettings['cloudinary.cloud_name'] = ''
  AppSettings['cloudinary.api_key'] = ''
  AppSettings['cloudinary.api_secret'] = ''  
end
