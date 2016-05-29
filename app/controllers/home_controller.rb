class HomeController < ApplicationController

  respond_to :html

  def index
    @topics = Topic.by_popularity.ispublic.front
    @rss = Topic.chronologic.active
    @articles = Doc.all_public_popular.with_translations(I18n.locale)
    @team = User.agents
    @feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{root_url}index.rss' />"
    @categories = Category.active.ordered.featured.all.with_translations(I18n.locale)
  end

  def set_client_id
    session[:client_id] = params[:client_id]
    render nothing: true
  end

end
