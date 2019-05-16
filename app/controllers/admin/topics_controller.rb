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
  before_action :fetch_counts, only: ['index','show', 'update_topic', 'user_profile']
  before_action :remote_search, only: ['index', 'show', 'update_topic']
  before_action :get_all_teams, except: ['shortcuts']
  before_action :set_hash_id_salt

  respond_to :js, :html, only: :show
  respond_to :js

  def index
    get_tickets_by_status
    team_tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "teams").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    @teams = ActsAsTaggableOn::Tag.where("id IN (?)", team_tag_ids)
    tracker("Admin-Nav", "Click", @status.titleize)
  end

  def show
    get_tickets_by_status
    @topic = Topic.find(params[:id])
    @doc = Doc.find(@topic.doc_id) if @topic.doc_id.present? && @topic.doc_id != 0

    if check_current_user_is_allowed? @topic
      # REVIEW: Try not opening message on view unless assigned
      # if @topic.current_status == 'new' && @topic.assigned?
      #   tracker("Agent: #{current_user.name}", "Opened Ticket", @topic.to_param, @topic.id)
      #   @topic.open
      # end
      get_all_teams
      @posts = @topic.posts.chronologic.includes(:user, :topic)
      tracker("Agent: #{current_user.name}", "Viewed Ticket", @topic.to_param, @topic.id)
      fetch_counts
      @include_tickets = false
    else
      @post = @topic.posts.new
      render status: :forbidden
    end
  end

  def new
    fetch_counts

    @topic = Topic.new(channel: AppSettings['settings.default_channel'])
    @user = params[:user_id].present? ? User.find(params[:user_id]) : User.new
  end

  def create
    @page_title = t(:start_discussion, default: "Start a New Discussion")
    @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"

    if params[:topic][:kind] == 'internal'
      create_internal_ticket
    else
      create_customer_conversation
    end
  end

  # Updates discussion status
  def update_topic

    logger.info("Starting update")

    #handle array of topics
    @topics = Topic.where(id: params[:topic_ids])

    bulk_post_attributes = []

    if params[:change_status].present?
      user_id = current_user.id || 2
      if ["closed", "reopen", "trash"].include?(params[:change_status])
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
      flash[:notice] = I18n.t("#{params[:change_status]}_message", user_name: User.find(user_id).name)
      # Calls to GA for close, reopen, assigned.
      tracker("Agent: #{current_user.name}", @action_performed, @topics.to_param, 0)

    end

    if params[:topic_ids].present?
      @topic = Topic.find(params[:topic_ids].last)
      @posts = @topic.posts.chronologic
    end

    fetch_counts
    get_all_teams
    get_tickets_by_status
    respond_to do |format|
      format.js {
        if params[:topic_ids].count > 1
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

    @topics.bulk_agent_assign(bulk_post_attributes, assigned_user.id) if bulk_post_attributes.present?

    if params[:topic_ids].count > 1
      get_tickets_by_status
    else
      @topic = Topic.find(@topics.first.id)
      @posts = @topic.posts.chronologic
    end

    logger.info("Count: #{params[:topic_ids].count}")

    fetch_counts
    get_all_teams
    get_tickets_by_status
    flash[:notice] = I18n.t(:assigned_message, assigned_to: assigned_user.name)

    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js {
        if params[:topic_ids].count > 1
          get_tickets_by_status
          render 'index'
        else
          render 'update_ticket', id: @topic.id
        end
      }
    end
  end

  def unassign_agent
    @topics = Topic.where(id: params[:topic_ids])
    bulk_post_attributes = []
    unless @topics.count == 0
      #handle array of topics
      @topics.each do |topic|
        bulk_post_attributes << {body: I18n.t(:unassigned_message, default: "This ticket has been unassigned."), kind: 'note', user_id: current_user.id, topic_id: topic.id}

        # Calls to GA
        tracker("Agent: #{current_user.name}", I18n.t(:unassigned_message, default: "This ticket has been unassigned."), @topic.to_param, 0)
      end

      @topics.bulk_agent_assign(bulk_post_attributes, nil) if bulk_post_attributes.present?

    end

    if params[:topic_ids].count > 1
      get_tickets_by_status
    else
      @topic = Topic.find(@topics.first.id)
      @posts = @topic.posts.chronologic
    end

    fetch_counts
    get_all_teams
    get_tickets_by_status
    flash[:notice] = I18n.t(:unassigned_message, default: "This ticket has been unassigned.")

    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js {
        if params[:topic_ids].count > 1
          get_tickets_by_status
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
    @topics.each{|topic| topic.update_pg_search_document}
    bulk_post_attributes = []

    @topics.each do |topic|
      if topic.forum_id == 1
        bulk_post_attributes << {body: I18n.t(:converted_to_ticket), kind: 'note', user_id: current_user.id, topic_id: topic.id}
        flash[:notice] = I18n.t(:converted_to_ticket)
      else
        bulk_post_attributes << {body: I18n.t(:converted_to_topic, forum_name: topic.forum.name), kind: 'note', user_id: current_user.id, topic_id: topic.id}
        flash[:notice] = I18n.t(:converted_to_topic, forum_name: topic.forum.name)
      end

      # Calls to GA
      tracker("Agent: #{current_user.name}", "Moved to  #{topic.forum.name}", @topic.to_param, 0)
    end

    # Bulk insert notes
    Post.bulk_insert values: bulk_post_attributes

    @topic = @topics.last
    @posts = @topic.posts.chronologic

    fetch_counts
    get_all_teams
    get_tickets_by_status


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

  def update
    @topic = Topic.find(params[:id])
    if @topic.update_attributes(topic_params)
      respond_to do |format|
        format.html {
          redirect_to(@topic)
        }
        format.json {
          respond_with_bip(@topic)
        }
      end
    else
      logger.info("error")
    end
  end

  def update_tags
    @topic = Topic.find(params[:id])
    previous_tagging = @topic.tag_list
    @topic.tag_list = params[:topic][:tag_list]
    if @topic.save && previous_tagging != @topic.tag_list
    # if @topic.update(tag_list: params[:tag][:tag_list])


      @topic.posts.create(
        body: t('tagged_with', topic_id: @topic.id, tagged_with: @topic.tag_list),
        user: current_user,
        kind: 'note',
      )

      flash[:notice] = t('tagged_with', topic_id: @topic.id, tagged_with: @topic.tag_list)
    end

    @posts = @topic.posts.chronologic

    fetch_counts
    get_all_teams
    get_tickets_by_status

    respond_to do |format|
      format.html {
        redirect_to admin_topic_path(@topic)
      }
      format.js {
        render 'update_ticket', id: @topic.id
      }
    end
  end

  def assign_team
    assigned_group = params[:assign_team]
    @topics = Topic.where(id: params[:topic_ids])
    bulk_post_attributes = []
    unless assigned_group.blank?
      #handle array of topics
      @topics.each do |topic|
        bulk_post_attributes << {body: I18n.t(:assigned_group, assigned_group: assigned_group), kind: 'note', user_id: current_user.id, topic_id: topic.id}

        # Calls to GA
        tracker("Agent: #{current_user.name}", "Assigned to #{assigned_group.titleize}", @topic.to_param, 0)
      end
    end

    @topics.bulk_group_assign(bulk_post_attributes, assigned_group) if bulk_post_attributes.present?

    flash[:notice] = I18n.t(:assigned_group, assigned_group: assigned_group)

    if params[:topic_ids].count > 1
      get_tickets_by_status
    else
      @topic = Topic.find(@topics.first.id)
      @posts = @topic.posts.chronologic
    end

    fetch_counts
    get_all_teams
    get_tickets_by_status


    respond_to do |format|
      format.html #render action: 'ticket', id: @topic.id
      format.js {
        if params[:topic_ids].count > 1
          render 'index'
        else
          render 'update_ticket', id: @topic.id
        end
      }
    end
  end

  def unassign_team
    @topic = Topic.where(id: params[:topic_ids]).first

    @topic.team_list = ""
    @topic.save

    @topic.posts.create(
      body: "This ticket was unassigned from all team groups",
      user: current_user,
      kind: 'note',
    )

    @posts = @topic.posts.chronologic

    fetch_counts
    get_all_teams
    get_tickets_by_status


    render 'update_ticket', id: @topic.id
  end

  def split_topic
    parent_topic = Topic.find(params[:topic_id])
    parent_post = Post.find(params[:post_id])

    @topic = Topic.new(
      name: t('new_discussion_topic_title', original_name: parent_topic.name, original_id: parent_topic.id, default: "Split from #{parent_topic.id}-#{parent_topic.name}"),
      user: parent_post.user,
      forum_id: parent_topic.forum_id,
      private: parent_topic.private,
      channel: parent_topic.channel,
      kind: parent_topic.kind,
    )

    @posts = @topic.posts

    if @topic.save
      @posts.create(
        body: parent_post.body,
        user: parent_post.user,
        kind: 'first',
        screenshots: parent_post.screenshots,
        attachments: parent_post.attachments,
      )

      parent_topic.posts.create(
        body: t('new_discussion_post', topic_id: @topic.id, default: "Discussion ##{@topic.id} was created from this one"),
        user: current_user,
        kind: 'note',
      )
    end

    fetch_counts
    get_all_teams
    get_tickets_by_status


    respond_to do |format|
      format.html { redirect_to admin_topic_path(@topic) }
      format.js { render 'update_ticket', id: @topic.id }
    end
  end

  def merge_tickets
    @topic = Topic.merge_topics(params[:topic_ids], current_user.id)

    @posts = @topic.posts.chronologic
    fetch_counts
    get_all_teams


    respond_to do |format|
      format.js { render 'show', id: @topic }
    end
  end

  def shortcuts
    render layout: 'admin-plain'
  end

  protected

  def create_customer_conversation
    @forum = Forum.find(1)
    @user = User.where("lower(email) = ?", params[:topic][:user][:email].downcase).first

    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: true,
      team_list: params[:topic][:team_list],
      channel: params[:topic][:channel],
      tag_list: params[:topic][:tag_list],
      priority: params[:topic][:priority],
      current_status: params[:topic][:current_status],
      assigned_user_id: params[:topic][:assigned_user_id]
    )
    if @user.nil?
      create_ticket_user
    else
      @topic.user_id = @user.id
    end

    fetch_counts
    respond_to do |format|
      if (@user.save || !@user.nil?) && @topic.save
        @post = @topic.posts.create(
          body: params[:topic][:post][:body],
          user_id: current_user.id,
          kind: params[:topic][:post][:kind],
          screenshots: params[:topic][:screenshots],
          attachments: params[:topic][:post][:attachments],
          cc: params[:topic][:post][:cc],
          bcc: params[:topic][:post][:bcc]
        )

        # Send copy of message to user
        PostMailer.new_post(@post .id).deliver_later

        # track event in GA
        tracker('Request', 'Post', 'New Topic')
        tracker('Agent: Unassigned', 'New', @topic.to_param)

        # Now that we are rendering show, get the posts (just one)
        # TODO probably can refactor this
        @posts = @topic.posts.chronologic.includes(:user)
        format.js {
          render action: 'show', id: @topic

        }
        format.html {
          render action: 'show', id: @topic
        }
      else
        format.html {
          render action: 'new'
        }
      end
    end

  end


  # Internal ticket is created by the agent.  Does not send messages to customer
  def create_internal_ticket
    @forum = Forum.find(1)
    @user = User.where("lower(email) = ?", params[:topic][:user][:email].downcase).first

    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: true,
      team_list: params[:topic][:team_list],
      channel: params[:topic][:channel],
      tag_list: params[:topic][:tag_list],
      priority: params[:topic][:priority],
      current_status: params[:topic][:current_status],
      assigned_user_id: params[:topic][:assigned_user_id],
      kind: 'internal'
    )
    if @user.nil?
      create_ticket_user
    else
      @topic.user_id = @user.id
    end

    fetch_counts
    respond_to do |format|
      if (@user.save || !@user.nil?) && @topic.save
        @post = @topic.posts.create(
          body: params[:topic][:post][:body],
          user_id: current_user.id,
          kind: params[:topic][:post][:kind],
          screenshots: params[:topic][:screenshots],
          attachments: params[:topic][:post][:attachments]
        )

        # track event in GA
        tracker('Request', 'Post', 'New Internal Topic')
        tracker('Agent: Unassigned', 'New', @topic.to_param)

        # Now that we are rendering show, get the posts (just one)
        # TODO probably can refactor this
        @posts = @topic.posts.chronologic.includes(:user)
        format.js {
          render action: 'show', id: @topic

        }
        format.html {
          render action: 'show', id: @topic
        }
      else
        format.html {
          render action: 'new'
        }
      end
    end


  end

  def create_ticket_user
    @token, enc = Devise.token_generator.generate(User, :reset_password_token)

    @user = @topic.build_user
    @user.reset_password_token = enc
    @user.reset_password_sent_at = Time.now.utc

    @user.name = params[:topic][:user][:name]
    @user.login = params[:topic][:user][:email].split("@")[0]
    @user.email = params[:topic][:user][:email]
    @user.home_phone = params[:topic][:user][:home_phone]
    @user.password = User.create_password

    @user.save

    # Send welcome email
    UserMailer.new_user(@user.id, @token).deliver_later
  end


  private

  def get_tickets
    if params[:status].nil?
      @status = "pending"
    else
      @status = params[:status]
    end

    case @status

    # when 'all'
    #   @topics = Topic.all.page params[:page]
    when 'new'
      @topics = Topic.unread.page params[:page]
    when 'active'
      @topics = Topic.active.page params[:page]
    # when 'unread'
    #   @topics = Topic.unread.all.page params[:page]
    when 'mine'
      @topics = Topic.mine(current_user.id).page params[:page]
    when 'pending'
      @topics = Topic.pending.mine(current_user.id).page params[:page]
    else
      @topics = Topic.where(current_status: @status).page params[:page]
    end
  end

  def topic_params
    params.require(:topic).permit(
      :name,
      :tag_list
    )
  end

  def set_hash_id_salt
    Hashid::Rails.configuration.salt=AppSettings['settings.anonymous_salt']
  end

end
