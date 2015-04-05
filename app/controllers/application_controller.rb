class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  private

  def fetch_counts
    @new = Topic.where(status: 'new').isprivate.count
    @open = Topic.where(status: 'open').isprivate.count
    @mine = Topic.where(status: 'open', assigned_user_id: current_user.id).isprivate.count
    @closed = Topic.where(status: 'closed').isprivate.count
    @spam = Topic.where(status: 'spam').isprivate.count

    @admins = User.admins
  end


end
