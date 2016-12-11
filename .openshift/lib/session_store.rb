require File.join(Rails.root,'lib','openshift_secret_generator.rb')

# Be sure to restart your server when you modify this file.

# Set token based on intialize_secret function (defined in initializers/secret_generator.rb)

Rails.application.config.session_store :cookie_store, :key => initialize_secret(
  :session_store,
  '_railsapp_session'
)

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# RailsApp::Application.config.session_store :active_record_store
