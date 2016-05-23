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

  respond_to :js, :html, only: :show
  respond_to :js

  def index
    @status = params[:status] || "pending"
    topics_raw = Topic.includes(user: :avatar_files).chronologic
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
    @tracker.event(category: "Admin-Nav", action: "Click", label: @status.titleize)
  end

  def show
    @topic = Topic.where(id: params[:id]).first
    if @topic.current_status == 'new'
      @tracker.event(category: "Agent: #{current_user.name}", action: "Opened Ticket", label: @topic.to_param, value: @topic.id)
      @topic.open
    end
    @posts = @topic.posts.chronologic
    @tracker.event(category: "Agent: #{current_user.name}", action: "Viewed Ticket", label: @topic.to_param, value: @topic.id)
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
      private: true )

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
          :screenshots => params[:topic][:screenshots])

        # Send email
        UserMailer.new_user(@user, @token).deliver_later

        # track event in GA
        @tracker.event(category: 'Request', action: 'Post', label: 'New Topic')
        @tracker.event(category: 'Agent: Unassigned', action: 'New', label: @topic.to_param)

        format.js {
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
    params[:topic_ids].each do |id|

      @topic = Topic.where(id: id).first
      @minutes = 0

      # actions for each status change
      unless params[:change_status].blank?
        case params[:change_status]
        when 'closed'
          @topic.close(current_user.id)
        when 'reopen'
          @topic.reopen(current_user.id)
        when 'trash'
          @topic.trash(current_user.id)
        else
          @topic.current_status = params[:change_status] unless params[:change_status].blank?
          @topic.save
        end
        @action_performed = "Marked #{params[:change_status].titleize}"
      end

      # Calls to GA for close, reopen, assigned
      @tracker.event(category: "Agent: #{current_user.name}", action: @action_performed, label: @topic.to_param, value: @minutes)

    end
    @posts = @topic.posts.chronologic

    fetch_counts
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

    @count = 0
    #handle array of topics
    params[:topic_ids].each do |id|

      @topic = Topic.where(id: id).first

      @minutes = 0
#      logger.info("inside loop")
#      logger.info(params[:assigned_user_id])
      unless params[:assigned_user_id].blank?

        # if message was unassigned previously, use the new assignee
        # this is to give note attribution below
        previous_assigned_id = @topic.assigned_user_id? ? @topic.assigned_user_id : params[:assigned_user_id]
        assigned_user = User.find(params[:assigned_user_id])
        @topic.assign(previous_assigned_id, assigned_user.id)

        # Create internal note
#        @topic.posts.create(user_id: previous_assigned_id, body: "Discussion has been transferred to #{assigned_user.name}.", kind: "note")

        # Calls to GA
        @tracker.event(category: "Agent: #{current_user.name}", action: "Assigned to #{assigned_user.name.titleize}", label: @topic.to_param, value: @minutes)

      end
      @count = @count + 1
    end

    if params[:topic_ids].count > 1
      get_tickets
    else
      @posts = @topic.posts.chronologic
    end

    logger.info("Count: #{params[:topic_ids].count}")

    fetch_counts
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
    params[:topic_ids].each do |id|

      @topic = Topic.where(id: id).first
      @topic.private = params[:private]
      @topic.forum_id = params[:forum_id]
      @topic.save


    end
    @posts = @topic.posts.chronologic

    fetch_counts
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
