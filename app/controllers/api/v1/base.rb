require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      format :json
      # use ::WineBouncer::OAuth2

      mount API::V1::Categories
      mount API::V1::Docs
      mount API::V1::Forums
      mount API::V1::Topics
      mount API::V1::Posts
      mount API::V1::Users
      add_swagger_documentation
    end
  end
end
