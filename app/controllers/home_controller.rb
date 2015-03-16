class HomeController < ApplicationController

  def index
    @topics = Topic.by_popularity.ispublic.front
    @rss = Topic.chronologic.active
    @docs = Doc.all_public_popular
    @private_topics = current_user.topics.isprivate if user_signed_in?

    @feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{root_url}index.rss' />"

    @topics = Topic.ispublic.tag_counts_on(:tags)

    respond_to do |format|
      format.html # index.rhtml
      format.rss
    end
  end

  def tag
    @topics = Topic.ispublic.tag_counts_on(:tags)
  end

end
