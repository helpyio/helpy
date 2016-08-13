class Admin::DashboardController < Admin::BaseController

  include StatsHelper
  before_action :fetch_counts, :only => ['index']

  def index
    #@users = PgSearch.multisearch(params[:q]).page params[:page]
    @topics = Topic.mine(current_user.id).pending.page params[:page]
    @posts = Post.reverse.all.limit(10)
  end

  def stats

    @start_date = params[:start_date] || Time.zone.today.at_beginning_of_week
    @end_date = params[:end_date] || Time.zone.today.at_end_of_day

    # @interval = params[:interval].try(:to_i) || 7
    @interval = params[:label] || 'this week'

    @topics = Topic.undeleted.where('topics.created_at >= ? AND topics.created_at <= ?', @start_date, @end_date)
    @topic_count = @topics.count

    # Note: Cannot use 'posts_count' counter cache; we only count posts with kind='reply' (not 'first' or 'note').
    responded_topic_ids = @topics
      .joins(:posts)
      .where(posts: { kind: 'reply' })
      .group('topics.id')
      .having('COUNT(posts.id) > 1')
      .ids
    @responded_topics = Topic.where(id: responded_topic_ids)
    @closed_topic_count = @topics.closed.count

    @posts = Post.where('created_at >= ? AND created_at <= ?', @start_date, @end_date)

    delays = @responded_topics.map { |t| t.posts.second.created_at - t.created_at }

    @median_first_response_time = median(delays) unless delays.empty?
  end


end
