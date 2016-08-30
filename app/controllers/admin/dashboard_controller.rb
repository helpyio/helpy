class Admin::DashboardController < Admin::BaseController

  include StatsHelper
  skip_before_action :verify_agent
  before_action :date_from_params, only: :stats
  before_action :verify_admin, only: :stats

  # Routes to different views depending on role of user
  def index
    if current_user.is_admin? || current_user.is_agent?
      redirect_to admin_topics_path
    elsif current_user.is_editor?
      redirect_to admin_categories_path
    else
      redirect_to root_url
    end
  end

  def stats
    @interval = i18n_interval_label(params[:label])
    @topics = Topic.undeleted.where(created_at: @start_date..@end_date)
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

    @posts = Post.where(created_at: @start_date..@end_date)

    delays = @responded_topics.map { |t| t.posts.second.created_at - t.created_at }

    @median_first_response_time = median(delays) unless delays.empty?

    @agents = Topic.undeleted.select(:assigned_user_id).where('assigned_user_id IS NOT NULL').distinct

    # figure out ideal column width
    # this could (and maybe should) be done with javascript
    @cols = number_of_cols(@agents.count)
  end

  private

  def number_of_cols(agent_count)
    cols = 6 - agent_count
    return cols >= 2 ? cols : 2
  end

  def i18n_interval_label(label)
    labels = %w(today yesterday this_week this_month)
    return labels.include?(label) ? t(label) : t('this_week')
  end
end
