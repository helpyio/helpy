class Admin::DashboardController < Admin::BaseController

  include StatsHelper
  before_action :fetch_counts, :only => ['index']

  def index
    #@users = PgSearch.multisearch(params[:q]).page params[:page]
    @topics = Topic.mine(current_user.id).pending.page params[:page]

    @posts = Post.reverse.all.limit(10)
  end

  # def index
  #   #@topics = Topic.mine(current_user.id).pending.page params[:page]
  #
  #   if current_user.is_admin? || current_user.is_agent?
  #     redirect_to admin_topics_path
  #   elsif current_user.is_editor?
  #     redirect_to admin_categories_path
  #   else
  #     redirect_to root_url
  #   end
  # end

  def stats
    @interval = params[:interval].try(:to_i) || 7
    @topics = Topic.undeleted.where('topics.created_at > ?', @interval.days.ago)
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

    @posts = Post.where('created_at > ?', @interval.days.ago)

    delays = @responded_topics.map { |t| t.posts.second.created_at - t.created_at }

    @median_first_response_time = median(delays) unless delays.empty?
  end


end
