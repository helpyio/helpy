class Admin::BaseController < ApplicationController

  layout 'admin'
  before_action :authenticate_user!
  helper_method :show_onboarding?

  # Here we are just checking if the onboarding should be shown, based on the
  # current admin username.
  def show_onboarding?
    User.first.email == 'admin@test.com' && current_user.email == 'admin@test.com' && current_user.is_admin?
  end

  protected

  def pipeline
    @pipeline = true
  end

  def remote_search
    @remote_search = true
  end

  def check_current_user_is_allowed? topic
    return if !topic.private || current_user.is_admin? || current_user.team_list.include?(topic.team_list.first)
    if topic.team_list.count > 0 && current_user.is_restricted? && (topic.team_list + current_user.team_list).count > 0
      render status: :forbidden
    end
  end

  def date_from_params
    case params[:label]
    when 'today'
      @start_date = Time.zone.today.midnight
      @end_date = Time.zone.today.at_end_of_day
    when 'yesterday'
      @start_date = Time.zone.yesterday.midnight
      @end_date = Time.zone.yesterday.at_end_of_day
    when 'this_week'
      @start_date = Time.zone.today.midnight.at_beginning_of_week
      @end_date = Time.zone.today.midnight.at_end_of_week
    when 'last_week'
      @start_date = Time.zone.today.last_week.midnight.at_beginning_of_week
      @end_date = Time.zone.today.last_week.midnight.at_end_of_week
    when 'this_month'
      @start_date = Time.zone.today.midnight.at_beginning_of_month
      @end_date = Time.zone.today.midnight.at_end_of_month
    when 'last_month'
      @start_date = Time.zone.today.last_month.midnight.at_beginning_of_month
      @end_date = Time.zone.today.last_month.midnight.at_end_of_month
    when 'interval'
      start_date = params[:start_date]
      end_date = params[:end_date]
      @start_date = start_date.present? ? start_date.to_datetime : Time.zone.today.at_beginning_of_week
      @end_date = end_date.present? ? end_date.to_datetime : Time.zone.today.at_end_of_day
    else
      @start_date = Time.zone.today.at_beginning_of_week
      @end_date = Time.zone.today.at_end_of_day
    end
  end
end
