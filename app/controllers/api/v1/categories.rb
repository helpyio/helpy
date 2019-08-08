module API
  module V1
    class Categories < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      resource :categories, desc: 'Manage knowledgebase categories' do

        # throttle max: 200, per: 1.minute

        # LIST ALL CATEGORIES
        desc "List all public categories", {
          entity: Entity::Category,
          notes: "Lists all active categories defined for the knowledgebase"
        }
        params do
          optional :docs, type: Boolean, desc: "Whether to include the documents in the response"
          optional :docs_limit, type: Integer, desc: "How many docs to return with the category"
          optional :visibility, type: String, desc: "Lets you filter categories by visibility.", values: ['all', 'public', 'internal']
        end
        get "", root: :categories do
          visibility = params[:visibility] || %w[all public]
          categories = Category.where(visibility: visibility).includes(:translations).active.ordered.all
          present categories, with: Entity::Category, docs: permitted_params[:docs], docs_limit: permitted_params[:docs_limit]
        end

        # SHOW CATEGORY
        desc "Return a single category with listing of docs", {
          entity: Entity::Category,
          notes: "Lists all active categories defined for the knowledgebase"
        }
        params do
          requires :id, type: String, desc: "Category to list docs from"
        end
        get ":id", root: :categories do
          category = Category.active.publicly.find(permitted_params[:id])
          present category, with: Entity::Category, docs: true
        end

        # CREATE NEW CATEGORY
        desc "Create a new category", {
          entity: Entity::Category,
          notes: "Create a new category"
        }
        params do
          requires :name, type: String, desc: "The name of the category of articles"
          optional :icon, type: String, desc: "An icon that represents the category"
          optional :keywords, type: String, desc: "Keywords that will be used for internal search and SEO"
          optional :title_tag, type: String, desc: "An alternate title tag that will be used if provided"
          optional :meta_description, type: String, desc: "A short description for SEO and internal purposes"
          optional :rank, type: Integer, desc: "The rank can be used to determine the ordering of categories"
          optional :front_page, type: Boolean, desc: "Whether or not the category should appear on the front page"
          optional :active, type: Boolean, desc: "Whether or not the category is live on the site"
          optional :visibility, type: String, desc: "Lets you filter categories by visibility.", values: ['all', 'public', 'internal']
        end
        post "", root: :categories do
          category = Category.create!(
            name: permitted_params[:name],
            icon: permitted_params[:icon],
            keywords: permitted_params[:keywords],
            title_tag: permitted_params[:title_tag],
            meta_description: permitted_params[:meta_description],
            rank: permitted_params[:rank],
            front_page: permitted_params[:front_page],
            active: permitted_params[:active],
            visibility: permitted_params[:visibility] || 'all'
          )
          present category, with: Entity::Category
        end

        # UPDATE CATEGORY
        desc "Update a single category", {
          entity: Entity::Category,
          notes: "Edit a single category"
        }
        params do
          requires :id, type: Integer, desc: "Category to update"
          requires :name, type: String, desc: "The name of the category of articles"
          optional :icon, type: String, desc: "An icon that represents the category"
          optional :keywords, type: String, desc: "Keywords that will be used for internal search and SEO"
          optional :title_tag, type: String, desc: "An alternate title tag that will be used if provided"
          optional :meta_description, type: String, desc: "A short description for SEO and internal purposes"
          optional :rank, type: Integer, desc: "The rank can be used to determine the ordering of categories"
          optional :front_page, type: Boolean, desc: "Whether or not the category should appear on the front page"
          optional :active, type: Boolean, desc: "Whether or not the category is live on the site"
          optional :visibility, type: String, desc: "Lets you filter categories by visibility.", values: ['all', 'public', 'internal']
        end
        patch ":id", root: :categories do
          category = Category.find(permitted_params[:id])
          category.update!(
            name: permitted_params[:name],
            icon: permitted_params[:icon],
            keywords: permitted_params[:keywords],
            title_tag: permitted_params[:title_tag],
            meta_description: permitted_params[:meta_description],
            rank: permitted_params[:rank],
            front_page: permitted_params[:front_page],
            active: permitted_params[:active],
            visibility: permitted_params[:visibility]
          )
          present category, with: Entity::Category
        end

      end

    end
  end
end
