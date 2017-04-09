class Admin::ReportsController < Admin::BaseController

  include StatsHelper
  before_action :verify_admin
  before_action :get_all_teams

  before_action :date_from_params
  before_action :scope_data
  before_action :set_interval
  before_action :set_timezone

  def index
    @number_of_days = (@end_date.to_date - @start_date.to_date).round
    if @number_of_days == 1
      get_hourly_stats
    else
      get_daily_stats
    end
  end

  def team
    @topics = Topic.undeleted.where('topics.created_at >= ? AND topics.created_at <= ?', @start_date, @end_date)
    @topic_count = @topics.count

    # Note: Cannot use 'posts_count' counter cache; we only count posts with kind='reply' (not 'first' or 'note').
    responded_topic_ids = @topics
      .joins(:posts)
      .where(posts: { kind: 'reply' })
      .group('topics.id')
      .having('COUNT(posts.id) > 0')
      .ids
    @responded_topics = Topic.where(id: responded_topic_ids)
    @closed_topic_count = @topics.closed.count

    @posts = Post.where('created_at >= ? AND created_at <= ?', @start_date, @end_date)

    delays = @responded_topics.map { |t| t.posts.second.created_at - t.created_at }

    @median_first_response_time = median(delays) unless delays.empty?
  end

  def groups
  end

  private

  def set_interval
    @interval = case params[:label]
                  when 'today'
                    t('today')
                  when 'yesterday'
                    t('yesterday')
                  when 'this_week'
                    t('this_week')
                  when 'last_week'
                    t('last_week')
                  when 'this_month'
                    t('this_month')
                  when 'last_month'
                    t('last_month')
                  when 'interval'
                    "Between #{@start_date.to_date} and #{@end_date.to_date}"
                  else
                    t('this_week')
                end

  end

  def scope_data
    @scoped_stats = Topic.where('topics.created_at >= ? AND topics.created_at <= ?', @start_date, @end_date)
    @scoped_posts = Post.where('created_at >= ? AND created_at <= ?', @start_date, @end_date)
  end

  def get_daily_stats
    @tickets = Topic.group_by_day(:created_at, range: @start_date..@end_date).count
    @closed = Topic.where(current_status: 'closed').group_by_day(:created_at, range: @start_date..@end_date).count
    @actions = Post.group_by_day(:created_at, range: @start_date..@end_date).count
    get_total_stats
  end

  def get_hourly_stats
    unless @scoped_stats.nil?
      @tickets = @scoped_stats.group_by_hour_of_day(:created_at).count
      @closed = @scoped_stats.where(current_status: 'closed').group_by_hour_of_day(:created_at).count
      @actions = @scoped_posts.group_by_hour_of_day(:created_at).count
    end
    get_total_stats
  end

  def get_total_stats
    @total_tickets = @scoped_stats.count
    @total_replies = @scoped_posts.where(kind: 'reply').count
    @total_closed = @scoped_stats.where(current_status: 'closed').count
    @total_activities = @scoped_posts.count
    filtered_stats = @scoped_stats.where("current_status = ? AND closed_date IS NOT NULL", 'closed')
    arr_time_differences = filtered_stats.map {|t| t.closed_date - t.created_at} unless filtered_stats.nil?
    @median_close_time = median(arr_time_differences).round unless arr_time_differences.size == 0
  end

  def set_timezone
    Groupdate.time_zone = current_user.time_zone
  end

end
