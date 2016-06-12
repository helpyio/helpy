require 'doorkeeper/grape/helpers'

module API
  module V1
    class Forums < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      include API::V1::Defaults

      resource :forums do
        desc "Return all forums"
        get "", root: :forums do
          Forum.all
        end

        desc "Return one forum"
        params do
          requires :id, type: String, desc: "ID of the forum"
        end
        get ":id", root: "forum" do
          Forum.where(id: permitted_params[:id]).first!
        end
      end
    end
  end
end
