class PostsController < ApplicationController

  before_filter :fetch_counts, :only => 'create'
  after_filter :send_message, :only => 'create'
  #after_filter :view_causes_vote, :only => 'index'

  def index
    @topic = Topic.undeleted.ispublic.where(id: params[:topic_id]).first#.includes(:forum)
    if @topic
      @posts = @topic.posts.active.all
      #@post = @topic.posts.new

      #@related = Topic.ispublic.by_popularity.front.tagged_with(@topic.tag_list)

      @feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{topic_posts_url(@topic)}.rss' />"

      @page_title = @topic.name.titleize
      @title_tag = "#{Settings.site_name}: #{@page_title}"
      add_breadcrumb t(:community, default: "Community"), forums_path
      add_breadcrumb @topic.forum.name.titleize, forum_topics_path(@topic.forum)
      add_breadcrumb @topic.name.titleize
    end

    respond_to do |format|
      if @topic
        format.html # index.rhtml
        format.xml  { render :xml => @posts.to_xml }
        format.rss  { render :layout => false}
      else
        format.html { redirect_to root_path}
      end
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
                     :user_id => current_user.id,
                     :kind => params[:post][:kind])

    respond_to do |format|
      if @post.save
        @posts = @topic.posts.active

        format.html { redirect_to topic_posts_path(@topic) }
        format.js {
          if current_user.admin?
            @admins = User.admins
            #@post = Post.new
            case @post.kind
            when "reply"
              @tracker.event(category: "Agent: #{current_user.name}", action: "Agent Replied", label: @topic.to_param) #TODO: Need minutes
            when "note"
              @tracker.event(category: "Agent: #{current_user.name}", action: "Agent Posted Note", label: @topic.to_param) #TODO: Need minutes
            end
            render 'admin/ticket'

          else #current_user is a customer
            unless @topic.assigned_user_id.nil?
              agent = User.find(@topic.assigned_user_id)
              @tracker.event(category: "Agent: #{agent.name}", action: "User Replied", label: @topic.to_param) #TODO: Need minutes
            end
          end

        }
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

  def send_message
    # TODO deliver/create a firstmessage to deliver on the initial post
    #Should only send when admin posts, not when user replies

    if current_user.admin?
      logger.info("admin is replying to message, so email")
      logger.info("Post ID Being sent: #{@post.body}")
      logger.info("Sending Email: #{Settings.send_email}")
      logger.info("Private Message: #{@topic.private}")
      TopicMailer.new_ticket(@post.topic).deliver if Settings.send_email == true && @topic.private == true
    else
      logger.info("reply is not from admin, don't email")
    end
  end

  def view_causes_vote
    if logged_in?
      @topic.votes.create unless current_user.admin?
    else
      @topic.votes.create
    end
  end
end
