class ResultController < ApplicationController
  respond_to :html, :js

  def index
    @results = PgSearch.multisearch(params[:q]).page params[:page]
    @page_title = I18n.translate(:how_can_we_help, default: "How can we help?")
    add_breadcrumb 'Search'
  end

end
