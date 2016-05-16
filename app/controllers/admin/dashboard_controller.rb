# NOTE: This is currently not used, but does have a working view.

class Admin::DashboardController < Admin::BaseController

  def dashboard
    @topics = Topic.mine(current_user.id).pending.page params[:page]
  end

end
