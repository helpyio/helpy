require 'doorkeeper/grape/helpers'

module API
  module V1
    class Docs < Grape::API
      # helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end
      before do
        authenticate!
      end

      include API::V1::Defaults
      resource :docs do
        ## SEARCH EXISTING DOCS
        desc "Search docs", {
          entity: Entity::Doc,
          notes: "Search for docs by query"
        }
        params do
          requires :q, type: String, desc: "The query term to search for"
          optional :page, type: Integer, desc: "The current page"
          optional :per_page, type: Integer, desc: "The number of results to return per page"
        end
        get "search", root: :doc do
          results = PgSearch.multisearch(permitted_params[:q])
                            .includes(:searchable)
                            .where(searchable_type: "Doc")
                            .page(permitted_params[:page])
                            .per(permitted_params[:per_page])
          docs = results.map(&:searchable)
          present docs, with: Entity::Doc, category: true
        end

        # SHOW A SINGLE DOC
        desc "Shows a single doc", {
          entity: Entity::Doc,
          notes: "Returns the full content of one doc"
        }
        params do
          requires :id, type: String, desc: "ID of the doc to show"
        end
        get ":id", root: "doc" do
          doc = Doc.where(id: permitted_params[:id]).first!
          present doc, with: Entity::Doc
        end

        # CREATE NEW DOC
        desc "Create a new doc", {
          entity: Entity::Doc,
          notes: "Create a new doc"
        }
        params do
          requires :title, type: String, desc: "The name of the articles"
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
        post "", root: :docs do
          doc = Doc.create!(
            title: permitted_params[:title],
            category_id: permitted_params[:category_id],
            body: permitted_params[:body],
            user_id: permitted_params[:user_id],
            keywords: permitted_params[:keywords],
            title_tag: permitted_params[:title_tag],
            meta_description: permitted_params[:meta_description],
            rank: permitted_params[:rank],
            front_page: permitted_params[:front_page],
            active: permitted_params[:active]
          )
          present doc, with: Entity::Doc
        end

        # UPDATE EXISTING DOC
        desc "Update a doc", {
          entity: Entity::Doc,
          notes: "Update a doc"
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
        patch ":id", root: :docs do
          doc = Doc.where(id: permitted_params[:id])
          doc.update!(
            title: permitted_params[:title],
            category_id: permitted_params[:category_id],
            body: permitted_params[:body],
            user_id: permitted_params[:user_id],
            keywords: permitted_params[:keywords],
            title_tag: permitted_params[:title_tag],
            meta_description: permitted_params[:meta_description],
            rank: permitted_params[:rank],
            front_page: permitted_params[:front_page],
            active: permitted_params[:active]
          )
          present doc, with: Entity::Doc
        end

        

      end
    end
  end
end
