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
      resource :tickets do
        desc "Returns all open tickets"
        params do
        end
        get "open", root: :topics do
          Forum.find(1).topics.open
        end

        desc "Returns all unread tickets"
        params do
        end
        get "unread", root: :topics do
          Forum.find(1).topics.unread
        end

        desc "Returns all pending tickets"
        params do
        end
        get "pending", root: :topics do
          Forum.find(1).topics.pending
        end

        desc "Returns all tickets for a user"
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        get "by_user", root: :topics do
          Forum.find(1).topics.where(user_id: permitted_params[:user_id]).all
        end

        desc "Returns a single topic"
        params do
          requires :id, type: String, desc: "Forum to list topics from"
        end
        get ":id", root: :topics do
          Topic.where(id: permitted_params[:id]).first
        end
      end

      resource :topics do
        desc "Return all public topics for a forum"
        params do
          requires :forum_id, type: String, desc: "Displays public community forum topics"
        end
        get "", root: :topics do
          Forum.find(permitted_params[:forum_id]).topics.all
        end
      end
    end
  end
end
