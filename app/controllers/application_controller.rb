class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb 'Home', :root_path

  private

  def fetch_counts
    @new = Topic.where(created_at: (Time.now.midnight - 1.day)..(Time.now.midnight + 1.day)).count
    @unread = Topic.where(status: 'new').count
    @open = Topic.where(status: 'open').count
    @mine = Topic.where(assigned_user_id: current_user.id).count
    @closed = Topic.where(status: 'closed').count
    @spam = Topic.where(status: 'spam').count

    @admins = User.admins
  end


end
