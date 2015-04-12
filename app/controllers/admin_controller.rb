class AdminController < ApplicationController

  layout 'admin'

  before_filter :authenticate_user!
  before_filter :verify_admin
  before_filter :fetch_counts, :only => ['dashboard','tickets','ticket']

  def dashboard
    #@users = PgSearch.multisearch(params[:q]).page params[:page]

  end

  def knowledgebase
    @categories = Category.alpha

    respond_to do |format|
      format.html { render :action => "knowledgebase" }
    end
  end

  def articles
    @category = Category.active.where(id: params[:category_id]).first
    @docs = @category.docs.ordered.active

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  def tickets

    case params[:status]

    when 'new'
      @topics = Topic.where(created_at: (Time.now.midnight - 1.day)..(Time.now.midnight + 1.day)).isprivate.page params[:page]
    when 'assigned'
      @topics = Topic.where(assigned_user_id: current_user.id).isprivate.page params[:page]
    else
      @topics = Topic.where(status: params[:status]).isprivate.page params[:page]
    end

    #unless params[:status] == 'active'
    #  @topics = Topic.where(status: params[:status]).isprivate.page params[:page]
    #else
    #  @topics = Topic.where(status: 'open').isprivate.page params[:page]
    #end

    respond_to do |format|
      format.html
      format.js
    end

  end

  # view ticket
  def ticket

    @topic = Topic.where(id: params[:id]).first
    @topic.open if @topic.status == 'new'

    @posts = @topic.posts

    respond_to do |format|
      format.html
      format.js
    end


  end

  def update_ticket
    @topic = Topic.where(id: params[:id]).first

    @topic.status = params[:status] unless params[:status].blank?
    @topic.assigned_user_id = params[:assigned_user_id] unless params[:assigned_user_id].blank?
    @topic.save!

    case params[:status]
    when 'closed'
      message = "This ticket has been closed by the support staff."
    when 'reopen'
      message = "This ticket has been reopened by the support staff."
    end

    #Add post indicating status change
    @topic.posts.create!(:user_id => current_user.id, :body => message) unless message.nil?

    @posts = @topic.posts


    fetch_counts
    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js
    end

  end

  def community

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

  private

  def verify_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
  end

end
