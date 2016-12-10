class Admin::SearchController < Admin::BaseController

  before_action :verify_agent
  before_action :fetch_counts
  before_action :remote_search
  before_action :get_all_teams

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
      search_topics
      template = 'admin/topics/index'
      tracker("Admin Search", "Topic Search", params[:q])
    elsif users.size == 1
      @user = users.first
      search_topics
      @topic = Topic.where(user_id: @user.id).first unless @user.nil?
      template = 'admin/topics/index'

      tracker("Admin Search", "User Search", params[:q])
      tracker("Agent: #{current_user.name}", "Viewed User Profile", @user.name)
    else
      @users = users.page params[:page]
      template = 'admin/users/users'
      tracker("Admin Search", "User Search", params[:q])
    end

    render template
  end

  protected

  def search_topics
    if current_user.is_restricted? && teams?
      @topics = Topic.admin_search(params[:q]).tagged_with(current_user.team_list, :any => true).page params[:page]
    else
      @topics = Topic.admin_search(params[:q]).page params[:page]
    end
  end

end
