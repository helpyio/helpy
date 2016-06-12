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
        desc "Return all forums", {
          entity: Entity::Forum,
          notes: "List all Forums"
        }
        get "", root: :forums do
          forums = Forum.all
          present forums, with: Entity::Forum
        end

        desc "Return one forum", {
          entity: Entity::Forum,
          notes: "Returns details of one forum"
        }
        params do
          requires :id, type: String, desc: "ID of the forum"
        end
        get ":id", root: "forum" do
          forum = Forum.where(id: permitted_params[:id]).first!
          present forum, with: Entity::Forum
        end
      end
    end
  end
end
