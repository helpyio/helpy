class HomeController < ApplicationController


  def index

    @topics = Topic.by_popularity.ispublic.front
    @rss = Topic.chronologic.active
    @articles = Doc.all_public_popular.with_translations(I18n.locale)
    @team = User.admins
    @feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{root_url}index.rss' />"
    @categories = Category.active.ordered.featured.all.with_translations(I18n.locale)

    #@topics = Topic.ispublic.tag_counts_on(:tags)

    respond_to do |format|
      format.html # index.rhtml
      format.rss
    end
  end

  #def tag
  #  @topics = Topic.ispublic.tag_counts_on(:tags)
  #end

end
