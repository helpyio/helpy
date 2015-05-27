ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'mandrill_mailer/offline'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all


  ActiveSupport::Deprecation.silenced = true
  
  # Add more helper methods to be used by all tests here...
  Settings.send_email = true
end

class ActionController::TestCase
  include Devise::TestHelpers
end
