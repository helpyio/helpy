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
    when 'this_month'
      @start_date = Time.zone.today.midnight.at_beginning_of_month
      @end_date = Time.zone.today.midnight.at_end_of_month
    else
      @start_date = Time.zone.today.at_beginning_of_week
      @end_date = Time.zone.today.at_end_of_day
    end
  end
end
