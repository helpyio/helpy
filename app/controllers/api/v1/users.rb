require 'doorkeeper/grape/helpers'

module API
  module V1
    class Users < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      include API::V1::Defaults
      resource :users do
        desc "Return all topics"
        get "", root: :users do
          User.all
        end
      end
    end
  end
end
