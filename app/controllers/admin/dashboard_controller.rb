class Admin::DashboardController < Admin::BaseController

  skip_before_action :verify_agent
  before_action :get_all_teams

  # Routes to different views depending on role of user
  def index
    #@topics = Topic.mine(current_user.id).pending.page params[:page]

    if (current_user.is_admin? || current_user.is_agent?) && (forums? || tickets?)
      redirect_to admin_topics_path
    elsif current_user.is_editor? && knowledgebase?
      redirect_to admin_categories_path
    elsif (current_user.is_admin? || current_user.is_agent?)
      redirect_to admin_users_path
    else
      redirect_to admin_blank_dashboard_path
    end
  end

end
