require 'doorkeeper/grape/helpers'

module API
  module V1
    class Categories < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      # LIST ALL CATEGORIES
      include API::V1::Defaults
      resource :categories do
        desc "Return all public categories", {
          entity: Entity::Category,
          notes: "Lists all active categories defined for the knowledgebase"
        }
        get "", root: :categories do
          categories = Category.active.all
          present categories, with: Entity::Category
        end
      end
    end
  end
end
