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
#  channel          :string           default("email")
#  kind             :string           default("ticket")
#  priority         :integer          default(1)
#

class TopicsController < ApplicationController
  before_action :authenticate_user!, only: %w[tickets ticket]
  before_action :allow_iframe_requests
  before_action :forums_enabled?, only: %w[index show]
  before_action :topic_creation_enabled?, only: %w[new create]
  before_action :get_all_teams, only: 'new'
  before_action :get_public_forums, only: %w[new create]

  layout "clean", only: %i[new index thanks]
  theme :theme_chosen

  # TODO Still need to so a lot of refactoring here!

  def index
    @forum = Forum.ispublic.where(id: params[:forum_id]).first
    if @forum
      @topics = if @forum.allow_topic_voting == true
                  @forum.topics.ispublic.by_popularity.page params[:page]
                else
                  @forum.topics.ispublic.chronologic.page params[:page]
                end
      @page_title = @forum.name
      add_breadcrumb t(:community, default: "Community"), forums_path
      add_breadcrumb @forum.name
    end
    respond_to do |format|
      format.html do
        redirect_to root_path unless @forum
      end
    end
  end

  def tickets
    @topics = current_user.topics.isprivate.undeleted.chronologic.page params[:page]
    @page_title = t(:tickets, default: 'Tickets')
    add_breadcrumb @page_title
    respond_to do |format|
      format.html # index.rhtml
    end
  end

  def ticket
    @topic = current_user.topics.undeleted.where(id: params[:id]).first
    if @topic
      @posts = @topic.posts.ispublic.chronologic.active.all.includes(:topic, :user, :screenshot_files)
      @page_title = "##{@topic.id} #{@topic.name}"
      add_breadcrumb t(:tickets, default: 'Tickets'), tickets_path
      add_breadcrumb @page_title
    end
    respond_to do |format|
      format.html do
        redirect_to root_path unless @topic
      end
    end
  end

  def new
    initialize_new_ticket_form_vars
  end

  def create
    @forum = params[:id].nil? ? Forum.find(params[:topic][:forum_id]) : Forum.find(params[:id])

    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: params[:topic][:private],
      doc_id: params[:topic][:doc_id],
      team_list: params[:topic][:team_list],
      channel: 'web'
    )

    if recaptcha_enabled? && !user_signed_in?
      unless verify_recaptcha(model: @topic)
        initialize_new_ticket_form_vars
        render :new && return
      end
    end

    if @topic.create_topic_with_user(params, current_user)
      @user = @topic.user
      @post = @topic.posts.create(
        body: params[:topic][:posts_attributes]["0"][:body],
        user_id: @user.id,
        kind: 'first',
        screenshots: params[:topic][:screenshots],
        attachments: params[:topic][:posts_attributes]["0"][:attachments]
      )

      unless user_signed_in?
        UserMailer.new_user(@user.id, @user.reset_password_token).deliver_later
      end

      # track event in GA
      tracker('Request', 'Post', 'New Topic')
      tracker('Agent: Unassigned', 'New', @topic.to_param)

      if @topic.private?
        redirect_to topic_thanks_path
      else
        redirect_to topic_posts_path(@topic)
      end
    else
      render 'new'
    end
  end

  def thanks
    @page_title = t(:thank_you, default: 'Thank You!')
  end

  def up_vote
    if user_signed_in?
      @topic = Topic.find(params[:id])
      @forum = @topic.forum
      @topic.votes.create(user_id: current_user.id)
      @topic.touch
      @topic.reload
    end
    respond_to do |format|
      format.js
    end
  end

  def tag
    @topics = Topic.ispublic.tag_counts_on(:tags)
  end

  private

  def initialize_new_ticket_form_vars
    @topic = Topic.new # unless @topic
    @user = @topic.build_user unless user_signed_in?
    @topic.posts.build # unless @topic.posts
    get_all_teams
    get_public_forums

    @page_title = t(:get_help_button, default: "Open a ticket")
    add_breadcrumb @page_title
  end

  def post_params
    params.require(:post).permit(
      :body,
      :kind,
      attachments: []
    )
  end

  def get_public_forums
    @forums = Forum.ispublic.all
  end
end
