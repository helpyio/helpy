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

    ticketID = Integer(params[:q]) rescue false

    # Searching for a single ticket, by ID should load the ticket page
    if users.size == 0 and ticketID != false # not a user search, so look for a topic
      @topics = Topic.admin_search(params[:q]).page params[:page]
      @topic = @topics.first
      template = "admin/topics/show"
      tracker("Admin Search", "Jump to topic", params[:q])

    # Searching for a topic by string, should display a list of matching topics
    elsif users.size == 0
      @topics = Topic.admin_search(params[:q]).page params[:page]
      @topic = @topics.first
      template = "admin/search/results"
      tracker("Admin Search", "Topic Search", params[:q])

    # Searching for a specific user should display that users profile
    elsif users.size == 1
      @user = users.first
      @topics = Topic.admin_search(params[:q]).page params[:page]
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


end
