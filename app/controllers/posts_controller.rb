# == Schema Information
#
# Table name: posts
#
#  id          :integer          not null, primary key
#  topic_id    :integer
#  user_id     :integer
#  body        :text
#  kind        :string
#  active      :boolean          default(TRUE)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  points      :integer          default(0)
#  attachments :string           default([]), is an Array
#  cc          :string
#  bcc         :string
#  raw_email   :text
#

class PostsController < ApplicationController

  # Make sure forums are enabled
  before_action :forums_enabled?, only: ['index','show']

  respond_to :js, only: [:up_vote]
  layout "clean", only: :index
  theme :theme_chosen

  def index
    @topic = Topic.undeleted.ispublic.where(id: params[:topic_id]).first#.includes(:forum)
    if @topic
      @posts = @topic.posts.ispublic.active.all.chronologic.includes(:user)
      @post = @topic.posts.new
      @page_title = "#{@topic.name}"
      add_breadcrumb t(:community, default: "Community"), forums_path
      add_breadcrumb @topic.forum.name, forum_topics_path(@topic.forum)
      add_breadcrumb @topic.name
    end

    redirect_to root_path unless @topic
  end

  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.new(post_params)
    @post.topic_id = @topic.id
    @post.user_id = current_user.id
    @post.screenshots = params[:post][:screenshots]

    respond_to do |format|
      if @post.save
        format.html {
          @posts = @topic.posts.ispublic.chronologic.active
          if @topic.public?
            # This is a forum post
            redirect_to @topic.doc.nil? ? topic_posts_path(@topic.id) : doc_path(@topic.doc_id)
          else
            # This post belongs to a ticket
            agent = User.find(@topic.assigned_user_id)
            tracker("Agent: #{agent.name}", "User Replied", @topic.to_param) #TODO: Need minutes
            redirect_to ticket_path(@topic.id)
          end
        }
        format.js {
          @posts = @topic.posts.ispublic.chronologic.active
          unless @topic.assigned_user_id.nil?
            agent = User.find(@topic.assigned_user_id)
            tracker("Agent: #{agent.name}", "User Replied", @topic.to_param) #TODO: Need minutes
          end
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
  end

  def post_params
    params.require(:post).permit(
      :body,
      :kind,
      {attachments: []}
    )
  end

end
