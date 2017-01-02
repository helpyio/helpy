module API
  module V1
    class Posts < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      resource :posts, desc: "Post replies to topics" do

        # throttle max: 200, per: 1.minute

        # CREATE NEW POST. THIS REPLIES TO BOTH COMMUNITY TOPICS AND PRIVATE TICKETS
        desc "Add a new reply to an existing discussion"
        params do
          requires :topic_id, type: Integer, desc: "Topic to add post to"
          requires :body, type: String, desc: "The post body"
          requires :user_id, type: Integer, desc: "The User ID of the poster"
          requires :kind, type: String, desc: "The kind of post, either 'reply' or 'note'"
          optional :cc, type: String, desc: "Comma separated list of emails to CC"
          optional :bcc, type: String, desc: "Comma separated list of emails to BCC"
        end
        post "", root: :posts do
          post = Post.create!(
            topic_id: permitted_params[:topic_id],
            body: permitted_params[:body],
            user_id: permitted_params[:user_id],
            kind: permitted_params[:kind],
            cc: permitted_params[:cc],
            bcc: permitted_params[:bcc]
          )
          present post, with: Entity::Post
        end

        # UPDATE POST. THIS REPLIES TO BOTH COMMUNITY TOPICS AND PRIVATE TICKETS
        desc "Update a post"
        params do
          requires :id, type: Integer, desc: "The Post ID"
          requires :body, type: String, desc: "The post body"
          requires :active, type: Boolean, desc: "Whether the post is live or not"
        end
        patch ":id", root: :posts do
          post = Post.find(permitted_params[:id])
          post.update!(
            body: permitted_params[:body],
            active: permitted_params[:active]
          )
          present post, with: Entity::Post
        end


      end
    end
  end
end
