require 'doorkeeper/grape/helpers'

module API
  module V1
    class Topics < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      include API::V1::Defaults

      # PRIVATE TICKET ENDPOINTS
      resource :tickets do

        # LIST BY STATUS
        desc "Returns all tickets by status", {
          entity: Entity::Topic,
          notes: "List all open tickets (private topics)"
        }
        params do
          requires :status, type: String, desc: "Status group (New, Open, Pending, etc.)"
        end
        get "status/:status", root: :topics do
          topics = Forum.find(1).topics.where(
            current_status: permitted_params[:status]
          )
          present topics, with: Entity::Topic
        end

        # LIST BY USER
        desc "Returns all tickets for a user", {
          entity: Entity::Topic,
          notes: "List all tickets (private topics) for a given user"
        }
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        get "by_user", root: :topics do
          topics = Forum.find(1).topics.where(user_id: permitted_params[:user_id]).all
          present topics, with: Entity::Topic
        end

        # SHOW ONE TICKET AND ITS THREAD
        desc "Returns a single ticket", {
          entity: Entity::Topic,
          notes: "Show one ticket (private topic)"
        }
        params do
          requires :id, type: String, desc: "Ticket ID"
        end
        get ":id", root: :topics do
          topic = Topic.includes(:posts).find(permitted_params[:id])#
          present topic, with: Entity::Topic
        end
      end

      # PUBLIC TOPIC ENDPOINTS FOR COMMUNITY FORUMS
      resource :topics do
        desc "Return all public topics for a forum", {
          entity: Entity::Topic,
          notes: "List all topics for a given forum"
        }
        params do
          requires :forum_id, type: String, desc: "Displays public community forum topics"
        end
        get "", root: :topics do
          topics = Forum.find(permitted_params[:forum_id]).topics.all
          present topics, with: Entity::Topic
        end
      end
    end
  end
end
