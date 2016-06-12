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
        desc "Return a doc"
        params do
          requires :id, type: String, desc: "ID of the doc"
        end
        get ":id", root: "doc" do
          Doc.where(id: permitted_params[:id]).first!
        end

        desc "Return all docs in a Category"
        params do
          requires :category_id, type: String, desc: "Category to list docs from"
        end
        get "", root: :docs do
          Doc.where(category_id: permitted_params[:category_id]).all
        end
      end
    end
  end
end
