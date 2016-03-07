# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  points     :integer          default(0)
#

class PostsController < ApplicationController

  before_action :authenticate_user!, :except => ['index', 'create', 'up_vote']
  before_action :verify_admin, :only => ['new', 'edit', 'update', 'destroy']
  before_action :instantiate_tracker

#  before_filter :fetch_counts, :only => 'create'
  after_action :send_message, :only => 'create'
#  after_filter :view_causes_vote, :only => 'index'

  layout "clean", only: [:index]


  def index
    @topic = Topic.undeleted.ispublic.where(id: params[:topic_id]).first#.includes(:forum)
    if @topic
      @posts = @topic.posts.ispublic.active.all.chronologic
      @post = @topic.posts.new

      #@related = Topic.ispublic.by_popularity.front.tagged_with(@topic.tag_list)

      #@feed_link = "<link rel='alternate' type='application/rss+xml' title='RSS' href='#{topic_posts_url(@topic)}.rss' />"

      @page_title = "#{@topic.name}"
      @title_tag = "#{Settings.site_name}: #{@page_title}"
      add_breadcrumb t(:community, default: "Community"), forums_path
      add_breadcrumb @topic.forum.name, forum_topics_path(@topic.forum)
      add_breadcrumb @topic.name
    end

    respond_to do |format|
      if @topic
        format.html # index.rhtml
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

    respond_to do |format|
      format.js
    end
  end

  def cancel
    @post = Post.where(id: params[:id]).first

    respond_to do |format|
      format.js
    end
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = Post.new(:body => params[:post][:body],
                     :topic_id => @topic.id,
                     :user_id => current_user.id,
                     :kind => params[:post][:kind],
                     :screenshots => params[:post][:screenshots])

    respond_to do |format|
      if @post.save

        format.html {
          @posts = @topic.posts.ispublic.chronologic.active
          redirect_to topic_posts_path(@topic)
        }
        format.js {
          if current_user.admin?
            fetch_counts

            @posts = @topic.posts.chronologic
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
            @posts = @topic.posts.ispublic.chronologic.active
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
    @post.body = params[:post][:body]
    @post.active = params[:post][:active]

    respond_to do |format|
      if @post.save
        format.js
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

  def up_vote

    if user_signed_in?
      @post = Post.find(params[:id])
      @post.votes.create(user_id: current_user.id)
      @topic = @post.topic
      @topic.touch
      @post.reload
    end

    respond_to do |format|
      format.js
    end

  end


  protected

  def send_message
    #Should only send when admin posts, not when user replies

    if current_user.admin?
      if @post.kind == 'first'
        email_locale = I18n.locale
      else
        email_locale = @topic.locale.nil? ? I18n.locale : @topic.locale.to_sym
      end

      I18n.with_locale(email_locale) do
        TopicMailer.new_ticket(@post.topic).deliver_now if @topic.private?
      end
    else
      logger.info("reply is not from admin, don't email") #might want to cchange this if we want admin notification emails
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
