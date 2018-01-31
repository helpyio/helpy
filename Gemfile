source 'https://rubygems.org'

# gem 'rails', '4.2.10'
gem 'rails', '~> 5.0.1'

# Use postgresql as the database for Active Record
gem 'pg', '~> 0.21.0'
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier'

# Explicitly include Nokogiri to control version
gem 'nokogiri'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails', '~> 5.0'

# Inline js validations
gem 'client_side_validations', '~> 11.0'
gem 'client_side_validations-simple_form', '~> 6.5'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks', '~> 2.5.3'
gem 'jquery-turbolinks', '~> 2.1.0'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder'

# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Summernote is the wysiwyg editor
gem 'jquery-minicolors-rails'
gem 'summernote-rails'
gem 'codemirror-rails'

# Ranked model gives the ability to rank articles and categories
gem 'ranked-model'

# Google Analytics Measurement Protocol
gem 'staccato'

gem "rails-settings-cached"
gem 'sucker_punch'

# Charting
gem "groupdate"
gem "chartkick"

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
gem 'rails-i18n'
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
# gem 'grape-kaminari'
gem 'grape-kaminari', :github => 'joshmn/grape-kaminari'
gem 'rack-cors', :require => 'rack/cors'

gem 'permalink_fu'
gem 'paper_trail'

gem 'acts-as-taggable-on'

gem 'kaminari'
gem 'kaminari-i18n'

# gem 'globalize-versioning', github: 'panyamin/globalize-versioning'
gem 'globalize-accessors'

gem 'gravtastic'

# File handling
gem 'cloudinary'
gem 'attachinary'

gem 'carrierwave'
gem "jquery-fileupload-rails"
gem 'mini_magick'

# Bootstrap/UI Gems
gem 'font-awesome-sass'
gem 'bootstrap-sass'
gem 'bootstrap_form'
gem 'simple_form'
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm'
gem 'rdiscount'
gem 'selectize-rails'
gem "bootstrap-switch-rails"
gem 'bootstrap-datepicker-rails'
gem 'bootstrap-select-rails'

gem 'config'

# Email/Mail Handling
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

gem 'devise_invitable'

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Faker is used for the populate script to create demo data
gem 'faker'

gem 'timecop' #used to populate

gem 'themes_on_rails'
gem "recaptcha", require: "recaptcha/rails"

gem 'best_in_place'

# Add onboarding component
# gem 'helpy_onboarding', path: 'vendor/helpy_onboarding'

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

gem 'bulk_insert', '~> 1.6'
gem 'roo'

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

end

group :production do
  # Uncomment this gem for Heroku:
  # gem 'rails_12factor'
  gem 'unicorn'
end

ruby '>= 2.3', '< 3.0'
