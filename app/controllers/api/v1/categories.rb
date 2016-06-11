require 'doorkeeper/grape/helpers'

module API
  module V1
    class Categories < Grape::API
      helpers Doorkeeper::Grape::Helpers

      before do
        doorkeeper_authorize!
      end

      include API::V1::Defaults
      resource :categories do
        desc "Return all public categories"
        get "", root: :categories do
          Category.active.all
        end
      end
    end
  end
end
