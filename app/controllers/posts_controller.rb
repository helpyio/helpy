class PostsController < ApplicationController

  add_breadcrumb 'Home', :root_path

  #after_filter :view_causes_vote, :only => 'index'

  def index
    @topic = Topic.where(id: params[:topic_id]).first#.includes(:forum)
    @posts = @topic.posts
    #@post = @topic.posts.new

    #@related = Topic.ispublic.by_popularity.front.tagged_with(@topic.tag_list)

    @meta_title = @topic.name
    @feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{topic_posts_url(@topic)}.rss' />"

    @page_title = @topic.name.titleize
    add_breadcrumb 'Community', forums_path
    add_breadcrumb @topic.forum.name.titleize, forum_topics_path(@topic.forum)
    add_breadcrumb @topic.name.titleize

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @posts.to_xml }
      format.rss  { render :layout => false}
    end
  end

  def show
    @post = Post.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
    end
  end

  def new
    @topic = Topic.find(params[:topic_id], :include => :forum)
    @post = Post.new
    @forums = Forum.all
  end

  def edit
    @post = Post.where(id: params[:id]).first
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.new(:body => params[:post][:body],
                     :topic_id => @topic.id,
                     :user_id => current_user.id)

    respond_to do |format|
      if @post.save
        flash[:notice] = 'Post was successfully created.'
        format.html { redirect_to topic_posts_path(@topic) }
      else
        format.html { render :action => "new" }
      end
    end
  end

  def update
    @post = Post.find(params[:id])

    respond_to do |format|
      if @post.update_attributes(params[:post])
        flash[:notice] = 'Post was successfully updated.'
         format.html { redirect_to topic_posts_path(@post.topic) }
      else
        format.html { render :action => "edit" }
      end
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    respond_to do |format|
       format.html { redirect_to topic_posts_path(@post.topic) }
    end
  end

  protected

  def view_causes_vote
    if logged_in?
      @topic.votes.create unless current_user.admin?
    else
      @topic.votes.create
    end
  end
end
