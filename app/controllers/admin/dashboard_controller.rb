class Admin::DashboardController < Admin::BaseController

  skip_before_action :verify_agent

  def index
    #@topics = Topic.mine(current_user.id).pending.page params[:page]

    if current_user.is_admin? || current_user.is_agent?
      redirect_to admin_topics_path
    elsif current_user.is_editor?
      redirect_to admin_categories_path
    else
      redirect_to root_url
    end
  end

end
