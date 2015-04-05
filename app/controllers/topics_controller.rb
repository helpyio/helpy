class TopicsController < ApplicationController

  before_filter :authenticate_user!, :except => ['show','index','tag','make_private']
  add_breadcrumb 'Home', :root_path


  # GET /topics
  # GET /topics.xml
  def index
    @forum = Forum.find(params[:forum_id])

    if user_signed_in? && current_user.admin?
      @topics = @forum.topics.active.chronologic.page params[:page]
    else
      @topics = @forum.topics.ispublic.chronologic.page params[:page]
    end

    #@feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{forum_topics_url}.rss' />"

    @page_title = @forum.name.titleize
    add_breadcrumb 'Community', forums_path
    add_breadcrumb @forum.name.titleize

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @topics.to_xml }
      format.rss
    end
  end

  def tickets
    #@forum = Forum.find(params[:forum_id])

    #if user_signed_in? && current_user.admin?
    #  @topics = @forum.topics.active.chronologic.page params[:page]
    #else
    #  @topics = @forum.topics.ispublic.chronologic.page params[:page]
    #end

    @topics = current_user.topics.isprivate.chronologic.page params[:page]
    @page_title = "Tickets"
    add_breadcrumb 'Tickets'

    #@feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{forum_topics_url}.rss' />"

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @topics.to_xml }
      format.rss
    end
  end


  # GET /topics/1
  # GET /topics/1.xml
  def show

  end

  # GET /topics/new
  def new

    add_breadcrumb 'Start a New Discussion'
    @page_title = 'Start a New Discussion'

    @topic = Topic.new

  end

  # GET /topics/1;edit
  def edit
    @topic = Topic.find(params[:id])
  end

  # POST /topics
  # POST /topics.xml
  def create
    params[:id].nil? ? @forum = Forum.find(params[:topic][:forum_id]) : @forum = Forum.find(params[:id])
    logger.info(@forum.name)

    @topic = @forum.topics.new(:name => params[:topic][:name], :user_id => current_user.id, :private => params[:topic][:private])
    @topic.save

#    @topic.tag_list = params[:tags]
#    @topic.save

    @post = @topic.posts.new(:body => params[:post][:body], :user_id => current_user.id)

    respond_to do |format|

      if @post.save
        format.html { redirect_to topic_posts_path(@topic.id) }
      else
        redirect_to :back
      end
    end
  end

  # PUT /topics/1
  # PUT /topics/1.xml
  def update
    @topic = Topic.find(params[:id])
    @topic.tag_list = params[:tags]
    respond_to do |format|
      if @topic.update_attributes(params[:topic])
        flash[:notice] = 'Topic was successfully updated.'
        format.html { redirect_to topic_posts_path(@topic) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @topic.errors.to_xml }
      end
    end
  end

  # DELETE /topics/1
  # DELETE /topics/1.xml
  def destroy
    @topic = Topic.find(params[:id])
    @topic.posts.each { |post| post.destroy }
    @topic.destroy

    respond_to do |format|
      format.html { redirect_to forum_topics_path(@topic.forum) }
      format.xml  { head :ok }
    end
  end

  def up_vote
    @topic = Topic.find(params[:id])
    @topic.votes.create(:user_id => current_user.id)
    logger.info(current_user.id)
    @topic.reload
    if request.xhr?
      render :update do |page|
        page['topic-stats'].replace_html :partial => 'posts/topic_stats'
      end
    else
      redirect_to topic_posts_path(@topic)
    end
  end

  def down_vote
    @topic = Topic.find(params[:id])
    @topic.votes.create(:user_id => current_user, :points => -1)

    @topic.reload
    if request.xhr?
      render :update do |page|
        page['topic-stats'].replace_html :partial => 'posts/topic_stats'
      end
    else
      redirect_to topic_posts_path(@topic)
    end
  end

  def make_private
    @topic = Topic.find(params[:id])
    private = params[:private]
    @topic.update_attribute(:private, private)
    @topic.save

    redirect_to :back
  end

  def tag
    @topics = Topic.ispublic.tag_counts_on(:tags)
  end
end
