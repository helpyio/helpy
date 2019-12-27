class Admin::AgentAssistantController < Admin::BaseController

  def index
    depth = params[:depth].present? ? params[:depth] : 10
    @results = Doc.active.publicly.agent_assist(params[:query]).first(depth)
    respond_to do |format|
      format.json { 
        render json: serialize_autocomplete_result(@results).to_json.html_safe 
      }
    end
  end

  private

  def serialize_autocomplete_result(results)
    serialized_result = []
    results.each do |result|
      serialized_result << {
        name: CGI::escapeHTML(result.title),
        content: result.meta_description.present? ? meta_content(result) : sanitized_content(result),
        link: category_doc_url(result.category_id, Doc.find(result.id))
      }
    end
    serialized_result
  end

  def sanitized_content(result)
    return nil if result.body.nil?
    ActionView::Base.full_sanitizer.sanitize(result.body).truncate_words(20)
  end

  def meta_content(result)
    result.meta_description
  end

end
