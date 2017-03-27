class Admin::ReportsController < Admin::BaseController

  include StatsHelper
  skip_before_action :verify_agent
  before_action :date_from_params, only: [:index, :team]
  before_action :verify_admin, only: [:index, :team]
  before_action :get_all_teams


  def index
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

    number_of_days = @end_date.to_date - @start_date.to_date
    if number_of_days == 1
      get_hourly_stats
    else
      get_daily_stats
    end
  end

  def team

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


  private

  def get_daily_stats
    get_stats_from_topics if @scoped_stats.blank?
  end

  def get_stats_from_topics
    @scoped_stats = Topic.where('topics.created_at >= ? AND topics.created_at <= ?', @start_date, @end_date)
    unless @scoped_stats.nil?
      @tickets = @scoped_stats.group_by_day(:created_at).count
      @closed = @scoped_stats.where(current_status: 'closed').group_by_day(:created_at).count
      @responded = {} #@scoped_stats.group_by_day(:created_at).sum(:responded)

      @total_tickets = @scoped_stats.count
      @total_replied = @scoped_stats.where('posts_count > 0').count
      @total_closed = @scoped_stats.where(current_status: 'closed').count
    end
  end

  def get_hourly_stats
    @scoped_stats = Topic.where('topics.created_at >= ? AND topics.created_at <= ?', @start_date, @end_date)

    unless @scoped_stats.nil?
      @tickets = @scoped_stats.group_by_hour_of_day(:created_at).count
      @closed = @scoped_stats.where(current_status: 'closed').group_by_hour_of_day(:created_at).count
      @responded = {} #@scoped_stats.group_by_day(:created_at).sum(:responded)

      @total_tickets = @scoped_stats.count
      @total_replied = @scoped_stats.where('posts_count > 0').count
      @total_closed = @scoped_stats.where(current_status: 'closed').count
    end
  end



end
