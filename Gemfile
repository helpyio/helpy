source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg'
gem 'pg_search'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
gem 'jquery-turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'trix'
gem 'ranked-model'
# Google Analytics Measurement Protocol
gem 'staccato'

gem 'devise'
gem 'devise-i18n'
gem 'devise-bootstrap-views'
gem 'omniauth'
gem 'omniauth-github'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'
gem 'omniauth-facebook'

gem 'rails-i18n', '~> 4.0.0'
gem 'i18n-country-translations'
gem 'route_translator'
gem 'http_accept_language'

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
gem 'twitter-bootstrap-rails'
gem 'twitter-bootstrap-rails-confirm'
gem 'rdiscount'

gem 'config'

gem 'daemons'
#gem 'mailman-rails'
gem 'mailman'#, require: false
gem 'mail_extract'

# Mandrill Integration
# gem 'mandrill-api'
# gem 'mandrill_mailer'
gem 'griddler'
gem 'griddler-mandrill'
gem 'griddler-sendgrid'
gem 'griddler-mailgun'
gem 'griddler-postmark'
gem 'griddler-mailin'

gem 'rails-timeago'

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

group :development, :test do

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 1.4.0'
  gem 'annotate'

end

group :development do
  gem "better_errors"
  gem "quiet_assets"

  # Check Eager Loading / N+1 query problems
  gem 'bullet'
  gem 'rubocop'

  gem 'scss-lint'
end

group :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'rspec'
  gem 'shoulda'
  gem 'factory_girl_rails'
end

group :production do
  gem 'newrelic_rpm'
  gem 'rails_12factor'
  gem 'unicorn'
end

ruby "2.2.1"
