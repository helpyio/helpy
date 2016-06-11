require "grape-swagger"

module API
  module V1
    class Base < Grape::API
      format :json
      mount API::V1::Docs
      mount API::V1::Categories
      add_swagger_documentation
    end
  end
end
