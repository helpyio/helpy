# Simplecov to give a report of the test coverage on local development environment
require 'simplecov'
SimpleCov.start 'rails'
require 'minitest/reporters'
Minitest::Reporters.use! [Minitest::Reporters::DefaultReporter.new(:color => true)]
ActiveSupport::TestCase.test_order = :parallel

require 'capybara/rails'
require 'capybara/minitest'
require 'capybara/email'

require 'minitest/retry'
Minitest::Retry.use!

class ActionDispatch::IntegrationTest
  include Capybara::DSL
  include Capybara::Minitest::Assertions
  Capybara.server = :webrick

  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

#require 'codeclimate-test-reporter'
#CodeClimate::TestReporter.start
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

# Requiring this library causes your jobs to run everything inline. So a call to the following
# will actually be SYNCHRONOUS
require 'sucker_punch/testing/inline'
require 'pry'

class ActiveSupport::TestCase
  include FactoryBot::Syntax::Methods
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  # Settings.send_email = false
end

Capybara.register_driver :chrome do |app|
  options = Selenium::WebDriver::Chrome::Options.new(args: %w[no-sandbox headless disable-gpu --disable-dev-shm-usage])
  Capybara::Selenium::Driver.new(app, browser: :chrome, options: options)
end

class ActionController::TestCase
  include Devise::Test::ControllerHelpers
end

def file
  @file ||= File.open(File.expand_path('test/fixtures/files/logo.png'))
end

def uploaded_file_object(klass, attribute, file, content_type = 'image/png')

  filename = File.basename(file.path)
  klass_label = klass.to_s.underscore

  ActionDispatch::Http::UploadedFile.new(
    tempfile: file,
    filename: filename,
    head: %Q{Content-Disposition: form-data; name="#{klass_label}[#{attribute}]"; filename="#{filename}"},
    content_type: content_type
  )
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
  AppSettings["settings.forums"] = true
  AppSettings["settings.tickets"] = true
  AppSettings["settings.knowledgebase"] = true
  AppSettings["settings.teams"] = true
  AppSettings["settings.welcome_email"] = true
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
  AppSettings['email.mail_smtp'] = '127.0.0.1' # Settings.mail_smtp
  AppSettings['email.mail_port'] = 1025 # Settings.mail_port
  AppSettings['email.mail_domain'] = Settings.mail_domain
  AppSettings['cloudinary.cloud_name'] = ''
  AppSettings['cloudinary.api_key'] = ''
  AppSettings['cloudinary.api_secret'] = ''
  AppSettings['theme.active'] = ENV['HELPY_THEME'] || 'helpy'
  AppSettings['onboarding.complete'] = '1'

  # assign all agents to receive notifications
  User.agents.each do |a|
    a.notify_on_private = true
    a.notify_on_public = true
    a.notify_on_reply = true
    a.save!
  end

  ActionMailer::Base.delivery_method = :test
  ActionMailer::Base.perform_deliveries = true

end
