require 'doorkeeper/grape/helpers'

module API
  module V1
    class Topics < Grape::API
      helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end
      before do
        authenticate!
      end
      
      include API::V1::Defaults

      # PRIVATE TICKET ENDPOINTS
      resource :tickets do

        # LIST BY STATUS
        desc "List all tickets by status", {
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
        desc "List all tickets for a user", {
          entity: Entity::Topic,
          notes: "List all tickets (private topics) for a given user"
        }
        params do
          requires :user_id, type: String, desc: "ID of the user"
        end
        get "user/:user_id", root: :topics do
          topics = Forum.find(1).topics.where(user_id: permitted_params[:user_id]).all
          present topics, with: Entity::Topic
        end

        # SHOW ONE TICKET AND ITS THREAD
        desc "Show a single ticket", {
          entity: Entity::Topic,
          notes: "Show one ticket (private topic)"
        }
        params do
          requires :id, type: String, desc: "Ticket ID"
        end
        get ":id", root: :topics do
          topic = Topic.includes(:posts).find(permitted_params[:id])#
          present topic, with: Entity::Topic, posts: true
        end

        # CREATE A NEW PRIVATE TICKET
        desc "Create a new ticket"
        params do
          requires :name, type: String, desc: "The subject of the ticket"
          requires :body, type: String, desc: "The post body"
          requires :user_id, type: String, desc: "the User ID"
        end

        post "", root: :topics do
          ticket = Topic.create!(
            forum_id: 1,
            name: params[:name],
            user_id: params[:user_id],
            private: true
          )
          topic.posts.create!(
            body: params[:body],
            user_id: params[:user_id],
            kind: 'first'
          )
          present ticket, with: Entity::Topic, posts: true
        end

        # UPDATE SINGLE TICKET
        desc "Update a private ticket"
        params do
          requires :id, type: Integer, desc: "The ticket ID to update"
          requires :name, type: String, desc: "The subject of the ticket"
          requires :body, type: String, desc: "The post body"
          requires :user_id, type: String, desc: "the User ID"
        end

        patch ":id", root: :topics do
          ticket = Topic.where(id: permitted_params[:id]).first
          ticket.update!(
            forum_id: 1,
            name: params[:name],
            user_id: params[:user_id],
            private: true
          )
          present ticket, with: Entity::Topic, posts: true
        end
      end

      # PUBLIC TOPIC ENDPOINTS FOR COMMUNITY FORUMS
      resource :topics do

        # LIST ALL TOPICS IN A FORUM
        desc "List all public topics for a forum", {
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

        # VOTE FOR A TOPIC
        desc "Vote for a topic", {
          entity: Entity::Topic,
          notes: "Vote for a given topic"
        }
        params do
          requires :id, type: Integer, desc: "The ID of the topic to vote for"
          #requires :user_id, type: Integer
        end
        put ':id/vote', root: :topics do
          topic = Topic.where(id: permitted_params[:id]).first
          topic.votes.create!(
            user_id: current_user #|| permitted_params[:user_id]
          )
          present topic, with: Entity::Topic
        end

      end

      # CREATE A NEW TOPIC



    end
  end
end
