source 'https://rubygems.org'

gem 'rails', '< 5.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.20.0'
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0.7'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Need to include for rails 5
gem 'ffi', '~> 1.17', '>= 1.17.1'
gem 'rdoc', '< 6.3'
# Getting the following error when running test
# NoMethodError: undefined method `new' for BigDecimal:Class
# https://stackoverflow.com/a/60491254/16682649
# https://github.com/ruby/bigdecimal#which-version-should-you-select
# NOTE: BigDecimal.new and subclassing always prints warning.
gem 'bigdecimal', '~> 1.4'
gem 'responders', '3.0.1'

# Explicitly include Nokogiri to control version
gem 'nokogiri', '~> 1.10', '>= 1.10.10'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Inline js validations
gem 'client_side_validations', '>= 9.3.2', '< 15'
gem 'client_side_validations-simple_form', '~> 6'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
gem 'jquery-turbolinks', '~> 2.1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.8'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 1.0.0', group: :doc

# Summernote is the wysiwyg editor
gem 'jquery-minicolors-rails'
gem 'summernote-rails'
gem 'codemirror-rails'

# Ranked model gives the ability to rank articles and categories
gem 'ranked-model'

# Google Analytics Measurement Protocol
gem 'staccato'

gem "rails-settings-cached", '< 0.5'
gem 'sucker_punch', '~> 2.0'

# Charting
gem "groupdate"
gem "chartkick"

# Auth Gems
gem 'devise', '4.7.3'
gem 'devise-i18n'
gem 'devise-bootstrap-views'
gem 'devise_invitable'
gem 'omniauth', '1.9.1'
gem "omniauth-rails_csrf_protection" # TODO: remove once https://github.com/omniauth/omniauth/pull/809 is resolved
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

# i18n gems
gem 'rails-i18n', '~> 5.0'
gem 'i18n-country-translations'
#gem 'route_translator', '< 6'
gem 'route_translator', '= 5.0.2'
gem 'http_accept_language'

# API gems
gem 'grape', '~> 1.8'
gem 'grape-swagger', '~> 1.4'
gem 'grape-entity', '~> 0.10'
gem 'grape-swagger-rails', '~> 0.3'
gem 'grape-swagger-entity', '~> 0.5'
# gem 'grape-attack' #uncomment for rate limiting
gem 'grape-kaminari', '~> 0.4'
gem 'kaminari-grape', '~> 1.0'
gem 'rack-cors', :require => 'rack/cors'

gem 'paper_trail', '< 11'
gem 'acts-as-taggable-on', '~> 8.1'

gem 'kaminari'
gem 'kaminari-i18n'

gem 'globalize', '<= 5.1.0'
gem 'globalize-versioning', '<= 0.4'
gem 'globalize-accessors'

gem 'gravtastic'

# File handling
gem 'cloudinary', '< 2'
#gem 'attachinary', '< 2'
gem 'attachinary', :git => 'https://github.com/ThomasConnolly/attachinary.git'

gem 'carrierwave', '< 3.0.0'
gem 'fog-aws', '< 3.6'
gem "jquery-fileupload-rails"
gem 'mini_magick'

# Bootstrap/UI Gems
# Pin font-awesome-sass to prevent error
gem 'font-awesome-sass', '~> 5.15'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'simple_form', '< 4'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm'
gem 'rdiscount'
gem 'selectize-rails'
gem "bootstrap-switch-rails", '3.3.3' # NOTE: IOS style switches broke with 3.3.4
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-select-rails'
gem 'gemoji'

gem 'config', '~> 1.1.0'

# Email/Mail Handling
gem 'daemons'
gem 'mailman'#, require: false
gem 'mail_extract'
gem 'email_reply_trimmer'

gem 'griddler'
gem 'griddler-mandrill'
gem 'griddler-sendgrid'
gem 'griddler-mailgun'
gem 'griddler-postmark'
gem 'griddler-sparkpost'

# html Email
gem 'inky-rb', '~> 1.3', require: 'inky'
gem 'premailer-rails'

gem 'rails-timeago'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Faker is used for the populate script to create demo data
gem 'faker'

gem 'timecop' #used to populate
gem "hashid-rails", "~> 1.0"
gem 'themes_on_rails'
gem "recaptcha", '< 3', require: "recaptcha/rails" # TODO: Update

gem 'best_in_place', '~> 3.1'

# Add onboarding component

group :development, :test do
  # Audit Gemfile for security vulnerabilities
  gem 'bundler-audit', require: false
  gem 'byebug', '11.0'
  gem 'pry'
  gem 'pry-byebug', '~> 3.9'
  gem 'spring', '~> 2.0.2'
  gem 'annotate'
  gem 'brakeman', require: false
  gem 'rubocop', '0.83.0'
  gem 'scss-lint'
  gem 'awesome_print'
  gem 'rb-readline'
  gem 'capybara', '< 3.30'

end

gem 'bulk_insert'
gem 'roo', '< 2.8'
gem 'ancestry'

group :development do
  gem "better_errors"
  gem "binding_of_caller"

  # Check Eager Loading / N+1 query problems
  # gem 'bullet'
  gem 'scout_apm'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 3.3'
  gem 'meta_request', '0.7.3'
end

group :test do
  gem 'minitest', '5.10.3'
  gem 'minitest-reporters'
  gem 'minitest-retry'
  gem 'shoulda', '~> 3.5' # Required for minitest
  gem 'shoulda-matchers', '~> 3.0'  # Required for minitest
  gem 'factory_bot', '< 6.3'
  gem 'factory_bot_rails', '< 6.4'
  gem 'webdrivers', '< 5'
  gem 'capybara-email', '~> 3.0'
  gem 'selenium-webdriver', '< 4.0'
  # gem 'chromedriver-helper'
  gem 'launchy'
  gem "codeclimate-test-reporter",require: nil
  gem 'simplecov', :require => false

  # remove this for Rails 5 because the function is already included
  #gem 'test_after_commit'
  # assigns has been extracted to a gem.
  gem 'rails-controller-testing'
end

group :production do
  # Uncomment this gem for Heroku:
  # gem 'rails_12factor'
  gem 'unicorn' #kept for backwards compatibility
  gem 'puma', '< 6'
end

ruby '>= 2.2', '< 2.7'
