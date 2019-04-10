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
          name: CGI::escapeHTML(result.searchable.name),
          content: result.searchable.post_cache.nil? ? nil : sanitized_post_cache(result),
          link: topic_posts_path(Topic.find(result.searchable_id))
          }
      else
        serialized_result << {
          name: CGI::escapeHTML(result.searchable.title),
          content: result.searchable.meta_description.present? ? meta_content(result) : sanitized_content(result),
          link: category_doc_path(result.searchable.category_id, Doc.find(result.searchable_id))
        }
      end
    end
    serialized_result
  end

  def sanitized_content(result)
    return nil if result.searchable.body.nil?
    ActionView::Base.full_sanitizer.sanitize(result.searchable.body).truncate_words(20)
  end

  def sanitized_post_cache(result)
    return nil if result.searchable.post_cache.nil?
    ActionView::Base.full_sanitizer.sanitize(result.searchable.post_cache).truncate_words(20)
  end

  def meta_content(result)
    result.searchable.meta_description
  end

end
