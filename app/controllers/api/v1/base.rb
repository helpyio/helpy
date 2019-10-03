require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      format :json

      # Uncomment to use rate limiting. Requires a Redis instance.
      # Set env['REDIS_URL'] (See: https://github.com/gottfrois/grape-attack)
      # use Grape::Attack::Throttle

      mount API::V1::Categories
      mount API::V1::Docs
      mount API::V1::Forums
      mount API::V1::Topics
      mount API::V1::Posts
      mount API::V1::Users
      mount API::V1::Search
      mount API::V1::Settings
      mount API::V1::Flags
      mount API::V1::Tags

      add_swagger_documentation \
        info: {
          title: "Helpy API Spec",
          description: "The Helpy API provides programmatic access to most functionality
           in Helpy.  Administrators and Agents can create an API key through the
           admin settings control panel to authenticate and gain
           access to the API endpoints.",
          # contact_name: "Contact name",
          # contact_email: "Contact@email.com",
          contact_url: "https://support.helpy.io/api",
          # license: "MIT.",
          # license_url: "www.The-URL-of-the-license.org",
          # terms_of_service_url: "www.The-URL-of-the-terms-and-service.com",
        }
    end
  end
end
