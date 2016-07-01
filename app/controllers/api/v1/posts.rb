require 'doorkeeper/grape/helpers'

module API
  module V1
    class Posts < Grape::API
      helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end
      before do
        authenticate!
      end

      include API::V1::Defaults
      resource :posts do

        # LIST ALL POSTS FOR TOPIC
        desc "Return all posts in a given topic", {
          entity: Entity::Post,
          notes: "List all posts for supplied topic"
        }
        params do
          requires :topic_id, type: String, desc: "Topic to list posts from"
        end
        get "", root: :posts do
          posts = Post.where(topic_id: permitted_params[:topic_id]).all
          present posts, with: Entity::Post
        end

        # CREATE NEW POST
        desc "Add a new post to an existing topic"
        params do
          requires :topic_id, type: String, desc: "Topic to add post to"
          requires :body, type: String, desc: "The post body"
          requires :user_id, type: String, desc: "the User ID"
          requires :kind, type: String, desc: "The kind of post"
        end
        post "create", root: :posts do
          post = Post.create!(
            topic_id: params[:topic_id],
            body: params[:body],
            user_id: params[:user_id],
            kind: 'reply'
          )
          present post, with: Entity::Post
        end


      end
    end
  end
end
