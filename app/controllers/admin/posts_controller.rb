class Admin::PostsController < Admin::BaseController

  before_action :verify_agent
  respond_to :js

  def edit
    @post = Post.where(id: params[:id]).first
  end

  def cancel
    @post = Post.where(id: params[:id]).first
  end

  def create
    @topic = Topic.find(params[:topic_id])
    # @post = Post.new(:body => params[:post][:body],
    #                  :topic_id => @topic.id,
    #                  :user_id => current_user.id,
    #                  :kind => params[:post][:kind],
    #                  :screenshots => params[:post][:screenshots])

    @post = Post.new(post_params)
    @post.topic_id = @topic.id
    @post.user_id = current_user.id

    respond_to do |format|
      if @post.save
        format.html {
          redirect_to admin_topic_path(@post.topic_id)
        }
        format.js {
          if params[:post][:resolved] == "1"
            @topic.close(current_user.id)
            tracker("Agent: #{current_user.name}", "Closed", @topic.to_param) #TODO: Need minutes
          end
          fetch_counts
          @posts = @topic.posts.chronologic

          @admins = User.agents
          #@post = Post.new
          case @post.kind
          when "reply"
            tracker("Agent: #{current_user.name}", "Agent Replied", @topic.to_param) #TODO: Need minutes
          when "note"
            tracker("Agent: #{current_user.name}", "Agent Posted Note", @topic.to_param) #TODO: Need minutes
          end
          render 'admin/topics/show'
        }
      else
        format.html { render :action => "new" }
        format.js {
          render 'admin/topics/show'
        }
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.body = params[:post][:body]
    @post.active = params[:post][:active]
    render action: 'update' if @post.save
  end

  def raw
    @post = Post.find(params[:id])
    render layout: false
  end

  def post_params
    params.require(:post).permit(
      :body,
      :kind,
      {screenshots: []},
      {attachments: []},
      :cc,
      :bcc
    )
  end

end
