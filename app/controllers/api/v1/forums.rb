module API
  module V1
    class Forums < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      resource :forums, desc: "Manage community forums." do

        # throttle max: 200, per: 1.minute

        # LIST ALL FORUMS
        desc "List all forums", {
          entity: Entity::Forum,
          notes: "List all Forums"
        }
        get "", root: :forums do
          forums = Forum.all
          present forums, with: Entity::Forum
        end

        # SHOW ONE FORUM
        desc "Show one forum", {
          entity: Entity::Forum,
          notes: "Returns details of one forum, including topics"
        }
        params do
          requires :id, type: String, desc: "ID of the forum"
          optional :topics_limit, type: Integer, desc: "How many topics to return"
        end
        get ":id", root: "forum" do
          forum = Forum.where(id: permitted_params[:id]).first!
          present forum, with: Entity::Forum, topics: true, topics_limit: permitted_params[:topics_limit]
        end

        # CREATE NEW FORUM
        desc "Create a new forum", {
          entity: Entity::Forum,
          notes: "Create a new forum"
        }
        params do
          requires :name, type: String, desc: "The name of the forum"
          requires :description, type: String, desc: "The description of the forum"
          optional :allow_post_voting, type: Boolean, desc: "Should topic replies be voteable?"
          optional :allow_topic_voting, type: Boolean, desc: "Should topics be voteable?"
          optional :layout, type: String, desc: "The layout used by the forum"
        end
        post "", root: :forums do
          forum = Forum.create!(
            name: permitted_params[:name],
            description: permitted_params[:description],
            allow_topic_voting: permitted_params[:allow_topic_voting],
            allow_post_voting: permitted_params[:allow_post_voting],
            layout: permitted_params[:layout]
          )
          present forum, with: Entity::Forum
        end

        # UPDATE EXISTING FORUM
        desc "Update a forum", {
          entity: Entity::Forum,
          notes: "Update a forum"
        }
        params do
          requires :id, type: Integer, desc: "The ID of the forum you are updating"
          requires :name, type: String, desc: "The name of the forum"
          requires :description, type: String, desc: "The description of the forum"
          optional :allow_post_voting, type: Boolean, desc: "Should topic replies be voteable?"
          optional :allow_topic_voting, type: Boolean, desc: "Should topics be voteable?"
          optional :layout, type: String, desc: "The layout used by the forum"
        end
        patch ":id", root: :forums do
          forum = Forum.find(permitted_params[:id])
          forum.update!(
            name: permitted_params[:name],
            description: permitted_params[:description],
            allow_topic_voting: permitted_params[:allow_topic_voting],
            allow_post_voting: permitted_params[:allow_post_voting],
            layout: permitted_params[:layout]
          )
          present forum, with: Entity::Forum
        end
      end
    end
  end
end
