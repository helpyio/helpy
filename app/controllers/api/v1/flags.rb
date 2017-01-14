module API
  module V1
    class Flags < Grape::API
      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      include Grape::Kaminari

      resource :flags, desc: "Flag post for review" do 
        desc "Flag a post for review"
        params do
          requires :post_id, type: Integer, desc: "The post to flag for review"
          requires :reason, type: String, desc: "The reason for flagging this post"
        end
        post "", root: :flags do
          post = Post.find(params[:post_id])
          topic = Topic.find(post.topic_id)
          forum = Forum.isprivate.first
          reason = params[:reason]
          user = current_user

          topics = forum.topics.create!(
            name: "Flagged for review: #{topic.name}",
            private: true,
            user_id: user.id
          )

          flag = Flag.create!(
            post_id: post.id,
            reason: reason,
            generated_topic_id: topics.id
          )

          topics.posts.create!(
            body: "Reason for flagging: #{flag.reason}",
            user_id: user.id,
            kind: "first"
          )

          present flag, with: Entity::Flag
        end
      end
    end
  end
end