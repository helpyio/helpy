class ResultController < ApplicationController
  respond_to :html, :js
  theme :theme_chosen

  def index
    @results = PgSearch.multisearch(params[:q]).page params[:page]
    @page_title = I18n.translate(:how_can_we_help, default: "How can we help?")
    add_breadcrumb 'Search'
  end

  def search
    depth = params[:depth].present? ? params[:depth] : 10
    @results = PgSearch.multisearch(params[:query]).first(depth)
    respond_to do |format|
      format.json { render :json => serialize_autocomplete_result(@results).to_json.html_safe }
    end
  end

  private

  def serialize_autocomplete_result(results)
    serialized_result = []
    results.each do |result|
      if result.searchable_type == "Topic"
        serialized_result << {
          name: result.searchable.name,
          content: result.searchable.post_cache.nil? ? nil : result.searchable.post_cache.truncate_words(20),
          link: topic_posts_path(Topic.find(result.searchable_id))
          }
      else
        serialized_result << {
          name: result.searchable.title,
          content: result.searchable.body.nil? ? nil : result.searchable.body.truncate_words(20),
          link: category_doc_path(result.searchable.category_id, Doc.find(result.searchable_id))
        }
      end
    end
    serialized_result
  end

end
