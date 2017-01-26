require File.expand_path('../boot', __FILE__)

require 'rails/all'
require "attachinary/orm/active_record"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Helpy
  class Application < Rails::Application

    config.assets.paths << Rails.root.join('vendor', 'assets', 'components')
    config.assets.paths << Rails.root.join("public",'uploads','logos')
    config.exceptions_app = self.routes

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}').to_s]

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # We are using active_job and currently the inline backend.  You may change this if
    # you want a more robust solution. The queue is used for emails.
    config.active_job.queue_adapter = :sucker_punch

    config.to_prepare do
      Devise::Mailer.layout "mailer" # email.haml or email.erb
    end

  end
end

module Api
  class Application < Rails::Application
    config.middleware.use Rack::Cors do
      allow do
        origins "*"
        resource "*", headers: :any, methods: [:get,
            :post, :put, :delete, :options]
      end
    end
    config.active_record.raise_in_transactional_callbacks = true
  end
end
