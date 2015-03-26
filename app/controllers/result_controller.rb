class ResultController < ApplicationController

  def index
    @results = PgSearch.multisearch(params[:q]).page params[:page]
    
  end

end
