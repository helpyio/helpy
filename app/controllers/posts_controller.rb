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
  #before_action :instantiate_tracker
  # after_action :send_message, :only => 'create'

  layout "clean", only: [:index]

  def index
    @topic = Topic.undeleted.ispublic.where(id: params[:topic_id]).first#.includes(:forum)
    if @topic
      @posts = @topic.posts.ispublic.active.all.chronologic.includes(:user)
      @post = @topic.posts.new
      @page_title = "#{@topic.name}"
      @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"
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

  def new
    @topic = Topic.find(params[:topic_id], :include => :forum)
    @post = Post.new
    @forums = Forum.all
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
          logger.info(@topic.doc_id)
          redirect_to @topic.doc.nil? ? topic_posts_path(@topic.id) : doc_path(@topic.doc_id)
        }
      else
        format.html { render :action => "new" }
      end
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

  def view_causes_vote
    if logged_in?
      @topic.votes.create unless current_user.admin?
    else
      @topic.votes.create
    end
  end
end
