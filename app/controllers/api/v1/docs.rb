require 'doorkeeper/grape/helpers'

module API
  module V1
    class Docs < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      include API::V1::Defaults
      resource :docs do
        desc "Return a doc", {
          entity: Entity::Doc,
          notes: "Returns the full content of one doc"
        }
        params do
          requires :id, type: String, desc: "ID of the doc"
        end
        get ":id", root: "doc" do
          doc = Doc.where(id: permitted_params[:id]).first!
          present doc, with: Entity::Doc
        end

        desc "Return all docs in a Category", {
          entity: Entity::Doc,
          notes: "List all docs in a category"
        }
        params do
          requires :category_id, type: String, desc: "Category to list docs from"
        end
        get "", root: :docs do
          docs = Doc.where(category_id: permitted_params[:category_id]).all
          present docs, with: Entity::Doc          
        end
      end
    end
  end
end
