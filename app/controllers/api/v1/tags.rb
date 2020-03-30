module API
  module V1
    class Tags < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin)
      end

      include API::V1::Defaults
      resource :tags, desc: "Manage tags." do

        # throttle max: 200, per: 1.minute

        # LIST ALL TAGS
        desc "List all tags", {
          entity: Entity::Tag,
          notes: "List all Tags"
        }
        get "", root: :tags do
          tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "tags", taggable_type: "Topic").includes(:tag).map {|tagging| tagging.tag.id }.uniq
          tags = ActsAsTaggableOn::Tag.where("id IN (?)", tag_ids).order(:name)
          present tags, with: Entity::Tag
        end

        # SHOW ONE TAG
        desc "Show one tag", {
          entity: Entity::Tag,
          notes: "Returns details of one tag"
        }
        params do
          requires :id, type: String, desc: "ID of the tag"
        end
        get ":id", root: :tag do
          tag = ActsAsTaggableOn::Tag.find(permitted_params[:id])
          present tag, with: Entity::Tag
        end

        # CREATE NEW TAG
        desc "Create a new tag", {
          entity: Entity::Tag,
          notes: "Create a new tag"
        }
        params do
          requires :name, type: String, desc: "The name of the tag"
          requires :description, type: String, desc: "The description of the tag"
          optional :color, type: String, desc: "The color hex code used for the tag, e.g. #ffcc33"
        end
        post "", root: :tags do
          tag = ActsAsTaggableOn::Tag.new(permitted_params.slice(:name, :description, :color))

          tag.save!
          ActsAsTaggableOn::Tagging.create!(tag_id: tag.id, taggable_type: 'Topic', context: "tags")

          present tag, with: Entity::Tag
        end

        # UPDATE EXISTING TAG
        desc "Update a tag", {
          entity: Entity::Tag,
          notes: "Update a tag"
        }
        params do
          requires :id, type: Integer, desc: "The ID of the tag you are updating"
          requires :name, type: String, desc: "The name of the tag"
          requires :description, type: String, desc: "The description of the tag"
          optional :color, type: String, desc: "The color hex code used for the tag, e.g. #ffcc33"
        end
        patch ":id", root: :tags do
          tag = ActsAsTaggableOn::Tag.find(permitted_params[:id])
          tag.update!(
            name: permitted_params[:name],
            description: permitted_params[:description],
            color: permitted_params[:color]
          )
          present tag, with: Entity::Tag
        end
      end
    end
  end
end
