require 'doorkeeper/grape/helpers'

module API
  module V1
    class Search < Grape::API
      helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end
      
      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      resource :search do
        ## SEARCH PUBLIC KNOWLEDGEBASE
        desc "Search the knowledgebase", {
          notes: "Search for docs, posts, and topics by query"
        }
        params do
          requires :q, type: String, desc: "The query term to search for"
          optional :type, type: String, desc: "The type of entity to search for"
          optional :page, type: Integer, desc: "The current page", default: 1
          optional :per_page, type: Integer, desc: "The number of results to return per page", default: 25
        end
        get "", root: :search do

          # Build initial results of the search
          results = PgSearch.multisearch(permitted_params[:q])
                            .page(permitted_params[:page])
                            .per(permitted_params[:per_page])

          # Scope results to supplied type
          if permitted_params[:type].present?
            # Convert pluralized into singular for the searcher
            type = permitted_params[:type].singularize.camelize
            results = results.where(searchable_type: type)
                             .includes(:searchable)            
          end

          # Grab total pagesnow in case we have to map the results array
          total_pages = results.total_pages 


          # Check what kind of entity we are searching for and modify the Entity output accordingly
          entity = case type
                   when nil
                     Entity::Search
                   when 'Doc', 'Topic', 'User'
                     results = results.map(&:searchable)
                     "Entity::#{type}".constantize
                   end

          present pages: { 
            page: permitted_params[:page], 
            per_page: permitted_params[:per_page],
            total_pages: total_pages
          }
          present :results, results, with: entity, category: true
        end
      end
    end
  end
end
