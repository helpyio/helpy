class Admin::BaseController < ApplicationController
  layout 'admin'
  before_action :authenticate_user!

  protected

  # These 3 methods provide feature authorization for admins. Editor is the most restricted,
  # agent is next and admin has access to everything:

  def verify_editor
    current_user.nil? ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_editor?)
  end

  def verify_agent
    current_user.nil? ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_agent?)
  end

  def verify_admin
    current_user.nil? ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_admin?)
  end

  def remote_search
    @remote_search = true
  end

  def check_current_user_is_allowed?(topic)
    return if !topic.private || current_user.is_admin? || current_user.team_list.include?(topic.team_list.first)
    if topic.team_list.count.positive? && current_user.is_restricted? && (topic.team_list + current_user.team_list).count.positive?
      render status: :forbidden
    end
  end

  def date_from_params
    @start_date = if params[:start_date].present?
                    params[:start_date].to_datetime
                  else
                    Time.zone.today.at_beginning_of_week
                  end

    @end_date = if params[:end_date].present?
                  params[:end_date].to_datetime
                else
                  Time.zone.today.at_end_of_day
                end
  end

  def fetch_counts
    if current_user.is_restricted? && teams?
      topics = Topic.tagged_with(current_user.team_list, any: true)
      @admins = User.agents # can_receive_ticket.tagged_with(current_user.team_list, :any => true)
    else
      topics = Topic.all
      @admins = User.agents.includes(:topics)
    end
    @new = topics.unread.count
    @unread = topics.unread.count
    @pending = Topic.mine(current_user.id).pending.count
    @open = topics.open.count
    @active = topics.active.count
    @mine = Topic.mine(current_user.id).count
    @closed = topics.closed.count
    @spam = topics.spam.count
  end
end
