class ResultController < ApplicationController
  respond_to :html, :js

  def index
    @results = PgSearch.multisearch(params[:q]).page params[:page]
    @page_title = I18n.translate(:how_can_we_help, default: "How can we help?")
    add_breadcrumb 'Search'
  end

  def search
    @results = PgSearch.multisearch(params[:query]).first(10)
    respond_to do |format|
      format.json { render :json => @results.map(&:content).to_json.html_safe }
    end
  end

end
