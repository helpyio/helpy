class Admin::PostsController < Admin::BaseController

  before_action :verify_agent
  after_action :send_message, :only => 'create'
  respond_to :js

  def edit
    @post = Post.where(id: params[:id]).first
  end

  def cancel
    @post = Post.where(id: params[:id]).first
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
      end
    end
  end

  def update
    @post = Post.find(params[:id])
    @post.body = params[:post][:body]
    @post.active = params[:post][:active]
    render action: 'update' if @post.save
  end

  protected

  def send_message
   return if @post.kind == 'note'

    #Should only send when admin posts, not when user replies
    if @post.kind == 'first'
      email_locale = I18n.locale
    else
      email_locale = @topic.locale.nil? ? I18n.locale : @topic.locale.to_sym
    end
    I18n.with_locale(email_locale) do
      TopicMailer.new_ticket(@post.topic).deliver_later if @topic.private?
    end

  end

end
