# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Rails.application.initialize!

# Get the current tag version
VERSION = '2.0.0'
REVISION = `git log --pretty=format:'%h' -n 1`
APP_VERSION = "#{VERSION}:#{REVISION}"
