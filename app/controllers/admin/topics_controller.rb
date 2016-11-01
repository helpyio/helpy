# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  locale           :string
#  doc_id           :integer          default(0)
#

class Admin::TopicsController < Admin::BaseController

  before_action :verify_agent
  before_action :fetch_counts, :only => ['index','show', 'update_topic', 'user_profile']
  before_action :pipeline, :only => ['index', 'show', 'update_topic']
  before_action :remote_search, :only => ['index', 'show', 'update_topic']
  before_action :get_all_teams

  respond_to :js, :html, only: :show
  respond_to :js

  def index
    @status = params[:status] || "pending"
    if current_user.is_restricted? && teams?
      topics_raw = Topic.all.tagged_with(current_user.team_list, :any => true)
    else
      topics_raw = Topic
    end
    topics_raw = topics_raw.includes(user: :avatar_files).chronologic
    get_all_teams
    case @status
    when 'all'
      topics_raw = topics_raw.all
    when 'new'
      topics_raw = topics_raw.unread
    when 'active'
      topics_raw = topics_raw.active
    when 'unread'
      topics_raw = topics_raw.unread.all
    when 'assigned'
      topics_raw = topics_raw.mine(current_user.id)
    when 'pending'
      topics_raw = topics_raw.pending.mine(current_user.id)
    else
      topics_raw = topics_raw.where(current_status: @status)
    end
    @topics = topics_raw.page params[:page]
    tracker("Admin-Nav", "Click", @status.titleize)
  end

  def show
    @topic = Topic.where(id: params[:id]).first

    # REVIEW: Try not opening message on view unless assigned
    check_current_user_is_allowed? @topic
    if @topic.current_status == 'new' && @topic.assigned?
      tracker("Agent: #{current_user.name}", "Opened Ticket", @topic.to_param, @topic.id)
      @topic.open
    end
    get_all_teams
    @posts = @topic.posts.chronologic.includes(:user)
    tracker("Agent: #{current_user.name}", "Viewed Ticket", @topic.to_param, @topic.id)
    fetch_counts
  end

  def new
    @topic = Topic.new
    @user = User.new
  end

  # TODO: Still need to refactor this method and the update methods into one
  def create
    @page_title = t(:start_discussion, default: "Start a New Discussion")
    @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"

    @forum = Forum.find(1)
    @user = User.where(email: params[:topic][:user][:email]).first

    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: true,
      team_list: params[:topic][:team_list]
    )

    if @user.nil?

      @user = @topic.build_user

      @token, enc = Devise.token_generator.generate(User, :reset_password_token)
      @user.reset_password_token = enc
      @user.reset_password_sent_at = Time.now.utc

      @user.name = params[:topic][:user][:name]
      @user.login = params[:topic][:user][:email].split("@")[0]
      @user.email = params[:topic][:user][:email]
      @user.password = User.create_password

    else
      @topic.user_id = @user.id
    end

    fetch_counts
    respond_to do |format|

      if (@user.save || !@user.nil?) && @topic.save

        @post = @topic.posts.create(
          :body => params[:topic][:post][:body],
          :user_id => @user.id,
          :kind => 'first',
          :screenshots => params[:topic][:screenshots],
          :attachments => params[:topic][:post][:attachments]
        )

        # Send email
        UserMailer.new_user(@user.id, @token).deliver_later

        # track event in GA
        tracker('Request', 'Post', 'New Topic')
        tracker('Agent: Unassigned', 'New', @topic.to_param)

        format.js {
          @topics = Topic.recent.page params[:page]
          render action: 'index'
        }
        format.html {
          @topics = Topic.recent.page params[:page]
          render action: 'index'
        }
      else
        format.html {
          render action: 'new'
        }
      end
    end
  end

  # Updates discussion status
  def update_topic

    logger.info("Starting update")

    #handle array of topics
    @topics = Topic.where(id: params[:topic_ids])

    bulk_post_attributes = []

    if params[:change_status].present?

      if ["closed", "reopen", "trash"].include?(params[:change_status])
        user_id = current_user.id || 2
        @topics.each do |topic|
          # prepare bulk params
          bulk_post_attributes << {body: I18n.t("#{params[:change_status]}_message", user_name: User.find(user_id).name), kind: 'note', user_id: user_id, topic_id: topic.id}
        end

        case params[:change_status]
        when 'closed'
          @topics.bulk_close(bulk_post_attributes)
        when 'reopen'
          @topics.bulk_reopen(bulk_post_attributes)
        when 'trash'
          @topics.bulk_trash(bulk_post_attributes)
        end
      else
        @topics.update_all(current_status: params[:change_status])
      end

      @action_performed = "Marked #{params[:change_status].titleize}"
      # Calls to GA for close, reopen, assigned.
      tracker("Agent: #{current_user.name}", @action_performed, @topics.to_param, 0)

    end

    if params[:topic_ids].present?
      @topic = Topic.find(params[:topic_ids].last)
      @posts = @topic.posts.chronologic
    end

    fetch_counts
    get_all_teams
    respond_to do |format|
      format.js {
        if params[:topic_ids].count > 1
          get_tickets
          render 'admin/topics/index'
        else
          render 'admin/topics/update_ticket', id: @topic.id
        end
      }
    end

  end

  # Assigns a discussion to another agent
  def assign_agent
    assigned_user = User.find(params[:assigned_user_id])
    @topics = Topic.where(id: params[:topic_ids])
    bulk_post_attributes = []
    unless params[:assigned_user_id].blank?
      #handle array of topics
      @topics.each do |topic|
        # if message was unassigned previously, use the new assignee
        # this is to give note attribution below
        previous_assigned_id = topic.assigned_user_id || params[:assigned_user_id]
        bulk_post_attributes << {body: I18n.t(:assigned_message, assigned_to: assigned_user.name), kind: 'note', user_id: previous_assigned_id, topic_id: topic.id}

        # Calls to GA
        tracker("Agent: #{current_user.name}", "Assigned to #{assigned_user.name.titleize}", @topic.to_param, 0)
      end
    end

    @topics.bulk_assign(bulk_post_attributes, assigned_user.id) if bulk_post_attributes.present?

    if params[:topic_ids].count > 1
      get_tickets
    else
      @topic = Topic.find(@topics.first.id)
      @posts = @topic.posts.chronologic
    end

    logger.info("Count: #{params[:topic_ids].count}")

    fetch_counts
    get_all_teams
    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js {
        if params[:topic_ids].count > 1
          get_tickets
          render 'index'
        else
          render 'update_ticket', id: @topic.id
        end
      }
    end
  end

  # Toggle privacy of a topic
  def toggle_privacy

    #handle array of topics
    @topics = Topic.where(id: params[:topic_ids])

    @topics.update_all(private: params[:private], forum_id: params[:forum_id])

    @topic = @topics.last
    @posts = @topic.posts.chronologic

    fetch_counts
    get_all_teams
    # respond_to do |format|
    #   format.js {
        if params[:topic_ids].count > 1
          render 'index'
        else
          render 'update_ticket', id: @topic.id
        end
    #   }
    # end

  end

  def assign_team
    @count = 0
    #handle array of topics
    params[:topic_ids].each do |id|
      @topic = Topic.where(id: id).first
      @minutes = 0
      @topic.team_list = params[:team]
      @topic.save

      @count = @count + 1
    end

    if params[:topic_ids].count > 1
      get_tickets
    else
      @posts = @topic.posts.chronologic
    end

    logger.info("Count: #{params[:topic_ids].count}")

    fetch_counts
    get_all_teams
    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js {
        if params[:topic_ids].count > 1
          get_tickets
          render 'index'
        else
          render 'update_ticket', id: @topic.id
        end
      }
    end
  end

  private

  def get_tickets
    if params[:status].nil?
      @status = "pending"
    else
      @status = params[:status]
    end

    case @status

    when 'all'
      @topics = Topic.all.page params[:page]
    when 'new'
      @topics = Topic.unread.page params[:page]
    when 'active'
      @topics = Topic.active.page params[:page]
    when 'unread'
      @topics = Topic.unread.all.page params[:page]
    when 'assigned'
      @topics = Topic.mine(current_user.id).page params[:page]
    when 'pending'
      @topics = Topic.pending.mine(current_user.id).page params[:page]
    else
      @topics = Topic.where(current_status: @status).page params[:page]
    end
  end


end
