class ResultController < ApplicationController


  def index

    @results = PgSearch.multisearch(params[:q]).page params[:page]
    @page_title = "How can we help?"
    add_breadcrumb 'Search'

    respond_to do |format|
      format.html
      format.js
    end
  end

end
