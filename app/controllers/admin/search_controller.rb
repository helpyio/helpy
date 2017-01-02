class Admin::SearchController < Admin::BaseController

  before_action :verify_agent
  before_action :fetch_counts
  before_action :remote_search
  before_action :get_all_teams
  before_action :search_date_from_params

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

    ticketID = Integer(params[:q]) rescue false

    # Searching for a single ticket, by ID should load the ticket page
    if users.size == 0 and ticketID != false # not a user search, so look for a topic
      @topics = Topic.admin_search(params[:q]).page params[:page]
      @topic = @topics.first
      template = "admin/topics/show"
      tracker("Admin Search", "Jump to topic", params[:q])

    # Searching for a topic by string, should display a list of matching topics
    elsif users.size == 0
      search_topics
      template = 'admin/search/search'
      tracker("Admin Search", "Topic Search", params[:q])

    # Searching for a specific user should display that users profile
    elsif users.size == 1
      @user = users.first
      @topics = Topic.where(user_id: @user.id).page params[:page]
      @topic = Topic.where(user_id: @user.id).first unless @user.nil?
      template = 'admin/users/show'

      tracker("Admin Search", "User Search", params[:q])
      tracker("Agent: #{current_user.name}", "Viewed User Profile", @user.name)

    # Finally, search all users for matches
    else
      @users = users.page params[:page]
      template = 'admin/users/users'
      tracker("Admin Search", "User Search", params[:q])
    end

    render template
  end

  protected

  def search_topics
    topics_to_search = Topic.where('created_at >= ?', @start_date).where('created_at <= ?', @end_date)
    if current_user.is_restricted? && teams?
      @topics = topics_to_search.admin_search(params[:q]).tagged_with(current_user.team_list, :any => true).page params[:page]
    else
      @topics = topics_to_search.admin_search(params[:q]).page params[:page]
    end
  end

  def search_date_from_params
    if params[:start_date].present?
      @start_date = params[:start_date].to_datetime
    else
      @start_date = Time.zone.today-1.month
    end

    if params[:end_date].present?
      @end_date = params[:end_date].to_datetime
    else
      @end_date = Time.zone.today.at_end_of_day
    end
  end


end
