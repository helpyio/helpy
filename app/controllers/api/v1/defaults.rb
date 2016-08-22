module API
  module V1
    module Defaults
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json

        helpers do
          def permitted_params
            @permitted_params ||= declared(params,
               include_missing: false)
          end

          def logger
            Rails.logger
          end

          def authenticate!
            error!('Unauthorized. Invalid or expired token.', 401) unless current_user
          end

          def current_user
            passed_token = request.headers["X-Token"] || params["token"]
            token = ApiKey.where(access_token: passed_token).first

            if token && !token.expired?
              @current_user = User.find(token.user_id)
            else
              false
            end
          end

          def restrict_to_role(role)
            error!('Unauthorized. Insufficient access priviledges.', 401) unless role.include?(current_user.role)
          end

        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: e.message, status: 422)
        end
      end
    end
  end
end
