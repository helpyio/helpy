class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb 'Home', :root_path

  private

  def fetch_counts
    @new = Topic.where(created_at: (Time.now.midnight - 1.day)..(Time.now.midnight + 1.day)).count
    @unread = Topic.unread.count
    @pending = Topic.mine(current_user.id).pending.count
    @open = Topic.open.count
    @mine = Topic.mine(current_user.id).count
    @closed = Topic.closed.count
    @spam = Topic.spam.count

    @admins = User.admins
  end


end
