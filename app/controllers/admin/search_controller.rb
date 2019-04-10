class Admin::SearchController < Admin::BaseController

  before_action :verify_agent
  before_action :fetch_counts
  before_action :remote_search
  before_action :get_all_teams
  before_action :search_date_from_params

  respond_to :html, :js

  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::TagHelper

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
      search_topics
      template = 'admin/search/search'
      tracker("Admin Search", "Topic Search", params[:q])
    elsif users.size == 1
      @user = users.first
      @topics = Topic.where(user_id: @user.id).page params[:page]
      @topic = Topic.where(user_id: @user.id).first unless @user.nil?
      template = 'admin/users/show'
      tracker("Admin Search", "User Search", params[:q])
      tracker("Agent: #{current_user.name}", "Viewed User Profile", @user.name)
    else
      @users = users.page params[:page]
      @roles = [[t('team'), 'team'], [t(:admin_role), 'admin'], [t(:agent_role), 'agent'], [t(:editor_role), 'editor'], [t(:user_role), 'user']]
      template = 'admin/users/index'
      tracker("Admin Search", "User Search", params[:q])
    end
    result_count = @topics.present? && @topics.total_count > 0 ? @topics.total_count : 0
    @header = "#{t(:results_found, count: result_count)} #{content_tag(:span, params[:q], class: 'more-important')}"

    render template
  end

  protected

  def search_topics
    topics_to_search = Topic.where('created_at >= ?', @start_date).where('created_at <= ?', @end_date)
    if current_user.is_restricted? && teams?
      @topics = topics_to_search.admin_search(params[:q]).tagged_with(current_user.team_list, :any => true).page params[:page]
    else
      @topics = topics_to_search.admin_search(params[:q]).page params[:page]
    end
  end

  def search_date_from_params
    if params[:start_date].present?
      @start_date = params[:start_date].to_datetime
    else
      @start_date = Time.zone.today-1.month
    end

    if params[:end_date].present?
      @end_date = params[:end_date].to_datetime
    else
      @end_date = Time.zone.today.at_end_of_day
    end
  end


end
