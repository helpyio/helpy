class AdminController < ApplicationController

  layout 'admin'

  before_filter :authenticate_user!
  before_filter :verify_admin
  before_filter :fetch_counts, :only => ['dashboard','tickets','ticket']

  def dashboard
    #@users = PgSearch.multisearch(params[:q]).page params[:page]

  end

  def knowledgebase
    @categories = Category.featured.alpha
    @nonfeatured = Category.where(front_page: false).alpha

    respond_to do |format|
      format.html { render :action => "knowledgebase" }
    end
  end

  def articles
    @category = Category.active.where(id: params[:category_id]).first
    @docs = @category.docs.ordered.alpha

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  def tickets

    if params[:status].nil?
      @status = "pending"
    else
      @status = params[:status]
    end

    case @status

    when 'new'
      @topics = Topic.where(created_at: (Time.now.midnight - 1.day)..(Time.now.midnight + 1.day)).page params[:page]
    when 'unread'
      @topics = Topic.unread.all.page params[:page]
    when 'assigned'
      @topics = Topic.mine(current_user.id).page params[:page]
    when 'pending'
      @topics = Topic.pending.mine(current_user.id).page params[:page]
    else
      @topics = Topic.where(current_status: @status).page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  # view ticket
  def ticket

    @topic = Topic.where(id: params[:id]).first
    if @topic.current_status == 'new'
      @tracker.event(category: "Agent: #{current_user.name}", action: "Opened Ticket", label: @topic.to_param, value: @topic.id)
      @topic.open
    end

    @posts = @topic.posts

    @tracker.event(category: "Agent: #{current_user.name}", action: "Viewed Ticket", label: @topic.to_param, value: @topic.id)

    respond_to do |format|
      format.html
      format.js
    end


  end

  def update_ticket
    @topic = Topic.where(id: params[:id]).first
    @minutes = 0

    # actions for each status change
    unless params[:change_status].blank?
      case params[:change_status]
      when 'closed'
        @topic.close
        message = "This ticket has been closed by the support staff."
      when 'reopen'
        @topic.open
        message = "This ticket has been reopened by the support staff."
      else
        @topic.current_status = params[:change_status] unless params[:change_status].blank?
      end
      @action_performed = "Marked #{params[:change_status].titleize}"
    end

    unless params[:assigned_user_id].blank?


      previous_assigned_id = @topic.assigned_user_id

      @topic.assigned_user_id = params[:assigned_user_id]
      @topic.current_status = 'pending'
      @topic.save!

      # Create internal note
      assigned_user = User.find(params[:assigned_user_id])
      @topic.posts.create(user_id: previous_assigned_id, body: "Discussion has been transferred to #{assigned_user.name}.", kind: "note")

      @action_performed = "Assigned to #{assigned_user.name.titleize}"

    end

    # Calls to GA for close, reopen, assigned
    @tracker.event(category: "Agent: #{current_user.name}", action: @action_performed, label: @topic.to_param, value: @minutes)

    #Add post indicating status change
    @topic.posts.create!(user_id: current_user.id, body: message, kind: "reply") unless message.nil?
    @posts = @topic.posts

    fetch_counts
    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js
    end

  end

  def communities
    @forums = Forum.where(private: false).order('name ASC')
  end

  def users
    @users = User.all.page params[:page]
    @user = User.new
  end

  def user
    @user = User.where(id: params[:id]).first
  end

  def user_search
    @users = PgSearch.multisearch(params[:q]).page params[:page]

    respond_to do |format|
      format.js
      format.html {
        render admin_users_path
      }
    end

  end



end
