# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Get the current tag version
APP_VERSION = `git describe --tags` unless defined? APP_VERSION
