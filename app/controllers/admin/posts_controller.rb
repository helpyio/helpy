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

    # refresh collections for UI
    get_all_teams
    get_tickets_by_status

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
    old_user = @post.user

    fetch_counts
    get_all_teams
    get_tickets_by_status

    @topic = @post.topic
    @posts = @topic.posts.chronologic

    if @post.update_attributes(post_params)
      update_topic_owner(old_user, @post) if @post.first?
      respond_to do |format|
        format.js {}
      end
    else
      render json: nil, status: 404
      logger.info("error")
    end
  end

  def search
    search_string = params[:user_search]
    @post_id = params[:post_id]
    @users = User.user_search(search_string)
    @users = nil if search_string.blank? || @users.empty?
  end

  def new_user
    @post_id = params[:post_id]
    @user = User.new
  end

  def change_owner_new_user
    @post = Post.find(params[:post_id])
    old_user = @post.user

    fetch_counts
    get_all_teams
    @topic = @post.topic
    @posts = @topic.posts.chronologic

    # Check user doesnt exist
    @user = User.find_by(email: params[:user][:email])

    # create user
    if @user.nil?
      @user = User.new

      @token, enc = Devise.token_generator.generate(User, :reset_password_token)
      @user.reset_password_token = enc
      @user.reset_password_sent_at = Time.now.utc

      @user.name = params[:user][:name]
      @user.login = params[:user][:email].split("@")[0]
      @user.email = params[:user][:email]
      @user.password = User.create_password
    end

    # assign user
    if @user.save && @post.update(user: @user)
      update_topic_owner(old_user, @post) if @post.first?
    end

    # re render topic
    render 'admin/posts/update'
  end

  def raw
    @post = Post.find(params[:id])
    render layout: false
  end

  private

  def post_params
    params.require(:post).permit(
      :body,
      :kind,
      {screenshots: []},
      {attachments: []},
      :cc,
      :bcc,
      :user_id,
      :active
    )
  end

  def update_topic_owner(old_owner, post)
      return if old_owner == post.user

      topic = post.topic
      topic.update(user: post.user)
      topic.posts.create(
        user: current_user,
        body: I18n.t('change_owner_note', old: old_owner.name, new: post.user.name, default: "The creator of this topic was changed from #{old_owner.name} to #{post.user.name}"),
        kind: "note",
      )
  end
end
