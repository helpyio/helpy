source 'https://rubygems.org'

gem 'rails', '4.2.7.1'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Explicitly include Nokogiri to control version
gem 'nokogiri', '>= 1.6.8'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Inline js validations
gem 'client_side_validations'
gem 'client_side_validations-simple_form'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Trix is the wysiwyg editor
gem 'trix'

# Ranked model gives the ability to rank articles and categories
gem 'ranked-model'

# Google Analytics Measurement Protocol
gem 'staccato'

gem "rails-settings-cached", '~> 0.5'
gem 'sucker_punch', '~> 2.0'

# Auth Gems
gem 'devise'
gem 'devise-i18n'
gem 'devise-bootstrap-views'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# i18n gems
gem 'rails-i18n', '~> 4.0.0'
gem 'i18n-country-translations'
gem 'route_translator'
gem 'http_accept_language'

# API gems
gem 'grape'
gem 'grape-swagger'
gem 'grape-entity'
gem 'grape-swagger-rails'
gem 'grape-swagger-entity'
gem 'grape-attack'
gem 'grape-kaminari'
gem 'rack-cors', :require => 'rack/cors'

gem 'permalink_fu'
gem 'paper_trail'

gem 'acts-as-taggable-on', '~>3.5'

gem 'kaminari'
gem 'kaminari-i18n'

gem 'globalize-versioning'
gem 'globalize-accessors'

gem 'gravtastic'

gem 'cloudinary', '1.1.2'
gem 'attachinary'

gem 'font-awesome-sass'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'simple_form'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm'
gem 'rdiscount'
gem 'selectize-rails'

gem 'config', '~> 1.1.0', git: 'https://github.com/railsconfig/config.git'

gem 'daemons'
gem 'mailman'#, require: false
gem 'mail_extract'

gem 'griddler'
gem 'griddler-mandrill'
gem 'griddler-sendgrid'
gem 'griddler-mailgun'
gem 'griddler-postmark'
gem 'griddler-mailin'
gem 'griddler-sparkpost'

gem 'rails-timeago'

gem 'devise_invitable', '~> 1.6'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'faker'

# RandomUser.me API
gem 'ruser', '~> 3.0'

gem 'timecop' #used to populate

gem 'themes_on_rails'
gem "recaptcha", require: "recaptcha/rails"

group :development, :test do
  # Audit Gemfile for security vulnerabilities
  gem 'bundler-audit', require: false
  gem 'byebug'
  gem 'pry'
  gem 'pry-byebug'
  gem 'spring', '~> 1.4.0'
  gem 'annotate'
  gem 'brakeman', require: false
  gem 'rubocop'
  gem 'scss-lint'
  gem 'awesome_print'
end

gem 'bulk_insert'

group :development do
  gem "better_errors"
  gem 'mailcatcher'

  # Check Eager Loading / N+1 query problems
  gem 'bullet'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'shoulda'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'selenium-webdriver'
  gem 'launchy'
  gem "codeclimate-test-reporter",require: nil
  gem 'simplecov', :require => false

  # remove this for Rails 5 because the function is already included
  gem 'test_after_commit'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'unicorn'
end

ruby "2.2.1"
