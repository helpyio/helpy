require 'doorkeeper/grape/helpers'

module API
  module V1
    class Posts < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      include API::V1::Defaults
      resource :posts do
        desc "Return all posts in a given topic"
        params do
          requires :topic_id, type: String, desc: "Topic to list posts from"
        end
        get "", root: :posts do
          Post.where(topic_id: permitted_params[:topic_id]).all
        end

        desc "Add a new post to an existing topic"
        params do
          requires :topic_id, type: String, desc: "Topic to add post to"
          requires :body, type: String, desc: "The post body"
          requires :user_id, type: String, desc: "the User ID"
          requires :kind, type: String, desc: "The kind of post"
        end
        post "create", root: :posts do
          Post.create!(
            topic_id: params[:topic_id],
            body: params[:body],
            user_id: params[:user_id],
            kind: 'reply'
          )
        end


      end
    end
  end
end
