class Admin::SearchController < Admin::BaseController

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
      template = 'admin/tickets'

      @tracker.event(category: "Admin Search", action: "Topic Search", label: params[:q])
      logger.info("Topic Search")
    elsif users.size == 1
        @user = users.first
        @topics = Topic.admin_search(params[:q]).page params[:page]
        @topic = Topic.where(user_id: @user.id).first unless @user.nil?
        template = 'admin/tickets'

        @tracker.event(category: "Admin Search", action: "User Search", label: params[:q])
        @tracker.event(category: "Agent: #{current_user.name}", action: "Viewed User Profile", label: @user.name)
        logger.info("Single User")
    else
        @users = users.page params[:page]
        template = 'admin/users/users'
        @tracker.event(category: "Admin Search", action: "User Search", label: params[:q])
        logger.info("User Search")
    end

    respond_to do |format|
      format.html {
        render template
      }
      format.js {
        render template
      }
    end
  end

  def user_search
    @users = User.user_search(params[:q]).page params[:page]

    respond_to do |format|
      format.js
      format.html {
        render admin_users_path
      }
    end
  end
end
