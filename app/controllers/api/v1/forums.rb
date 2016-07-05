require 'doorkeeper/grape/helpers'

module API
  module V1
    class Forums < Grape::API
      helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end
      before do
        authenticate!
      end

      include API::V1::Defaults
      resource :forums do

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
          notes: "Returns details of one forum"
        }
        params do
          requires :id, type: String, desc: "ID of the forum"
        end
        get ":id", root: "forum" do
          forum = Forum.where(id: permitted_params[:id]).first!
          present forum, with: Entity::Forum
        end

        # CREATE NEW FORUM
        desc "Create a new forum", {
          entity: Entity::Forum,
          notes: "Create a new forum"
        }
        params do
          requires :name, type: String, desc: "The name of the forum"
          requires :allow_post_voting, type: String, desc: "Should topic replies be voteable?"
          requires :allow_topic_voting, type: String, desc: "Should topics be voteable?"
          requires :layout, type: String, desc: "The author of the article"
        end
        post "", root: :forums do
          forum = Forum.create!(
            name: permitted_params[:name],
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
          requires :id, type: Integer, desc: "The ID of the Doc being updated"
          requires :title, type: String, desc: "The name of the category of articles"
          requires :category_id, type: Integer, desc: "The category the doc belongs to"
          requires :body, type: String, desc: "The body/text of the article"
          requires :user_id, type: Integer, desc: "The author of the article"
          optional :keywords, type: String, desc: "Keywords that will be used for internal search and SEO"
          optional :title_tag, type: String, desc: "An alternate title tag that will be used if provided"
          optional :meta_description, type: String, desc: "A short description for SEO and internal purposes"
          optional :rank, type: Integer, desc: "The rank can be used to determine the ordering of docs"
          optional :front_page, type: String, desc: "Whether or not the doc should appear on the front page"
          optional :active, type: Boolean, desc: "Whether or not the doc is live on the site"
        end
        patch ":id", root: :forums do
          forum = Forum.where(id: permitted_params[:id])
          forum.update!(
            name: permitted_params[:name],
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
