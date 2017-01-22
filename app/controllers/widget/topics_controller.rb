class Widget::TopicsController < Widget::BaseController

  layout 'widget'
  before_action :allow_iframe_requests

  def new
    @page_title = t(:start_discussion, default: "Start a New Discussion")
    @locale = http_accept_language.compatible_language_from(I18n.available_locales)
    @forums = Forum.ispublic.all
    @topic = Topic.new
    @user = @topic.build_user unless user_signed_in?
    @topic.posts.build
    add_breadcrumb @page_title
  end


  def create

    @forum = Forum.find(1)
    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: params[:topic][:private],
      doc_id: params[:topic][:doc_id],
      team_list: params[:topic][:team_list],
      channel: 'widget')

    @topic.private = true

    if @topic.create_topic_with_user(params, current_user)
      @user = @topic.user
      @post = @topic.posts.create(
        :body => params[:topic][:posts_attributes]['0'][:body],
        :user_id => @user.id,
        :kind => 'first'
        )

      if !user_signed_in?
        UserMailer.new_user(@user.id, @user.reset_password_token).deliver_later
      end

      # track event in GA
      tracker('Request', 'Post', 'New Topic')
      tracker('Agent: Unassigned', 'New', @topic.to_param)

      redirect_to widget_thanks_path
    else
      render 'new'
    end

  end

  def thanks
     @page_title = t(:thank_you, default: 'Thank You!')
  end


end
