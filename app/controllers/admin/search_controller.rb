class Admin::SearchController < Admin::BaseController

  before_action :verify_agent
  before_action :fetch_counts
  before_action :pipeline
  before_action :remote_search
  respond_to :html, :js

  # simple search tickets by # and user
  def topic_search

    # search for user, if [one] found, we'll give details on that person
    # if more than one found, we'll list them, if search is for "users" then show all
    if params[:q] == 'users'
      users = User.all
    else
      users = User.user_search(params[:q])
    end

    if users.size == 0 # not a user search, so look for topics
      @topics = Topic.admin_search(params[:q]).page params[:page]
      template = 'admin/topics/index'
      tracker("Admin Search", "Topic Search", params[:q], nil)
    elsif users.size == 1
      @user = users.first
      @topics = Topic.admin_search(params[:q]).page params[:page]
      @topic = Topic.where(user_id: @user.id).first unless @user.nil?
      template = 'admin/topics/index'

      tracker("Admin Search", "User Search", params[:q], nil)
      tracker("Agent: #{current_user.name}", "Viewed User Profile", @user.name, nil)
    else
      @users = users.page params[:page]
      template = 'admin/users/users'
      tracker("Admin Search", "User Search", params[:q], nil)
    end

    render template
  end


end
