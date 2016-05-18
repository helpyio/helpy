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

class TopicsController < ApplicationController

  before_action :authenticate_user!, :only => ['tickets','ticket']
  before_action :allow_iframe_requests

  layout "clean", only: [:new, :index, :thanks]

  # TODO Still need to so a lot of refactoring here!

  def index
    @forum = Forum.ispublic.where(id: params[:forum_id]).first
    if @forum
      if @forum.allow_topic_voting == true
        @topics = @forum.topics.ispublic.by_popularity.page params[:page]
      else
        @topics = @forum.topics.ispublic.chronologic.page params[:page]
      end
      @page_title = @forum.name
      add_breadcrumb t(:community, default: "Community"), forums_path
      add_breadcrumb @forum.name
    end
    respond_to do |format|
      format.html {
        redirect_to root_path unless @forum
      }
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
      @posts = @topic.posts.ispublic.chronologic.active.all
      @page_title = "##{@topic.id} #{@topic.name}"
      add_breadcrumb t(:tickets, default: 'Tickets'), tickets_path
      add_breadcrumb @page_title
    end
    respond_to do |format|
      format.html {
        redirect_to root_path unless @topic
      }
    end
  end

  def new
    @page_title = t(:start_discussion, default: "Start a New Discussion")
    @forums = Forum.ispublic.all
    @topic = Topic.new
    @user = @topic.build_user unless user_signed_in?
    add_breadcrumb @page_title
  end

  def create
    # @page_title = t(:start_discussion, default: "Start a New Discussion")
    # add_breadcrumb @page_title
    # @title_tag = "#{AppSettings['settings.site_name']}: #{@page_title}"

    params[:id].nil? ? @forum = Forum.find(params[:topic][:forum_id]) : @forum = Forum.find(params[:id])
    logger.info(@forum.name)

    @topic = @forum.topics.new(
      name: params[:topic][:name],
      private: params[:topic][:private],
      doc_id: params[:topic][:doc_id] )

    unless user_signed_in?
      # User is not signed in, lets see if we can recognize the email address
      @user = User.where(email: params[:topic][:user][:email]).first

      if @user
        logger.info("User found")
        @topic.user_id = @user.id

      else #User not found, lets build it

        @user = @topic.build_user

        @token, enc = Devise.token_generator.generate(User, :reset_password_token)
        @user.reset_password_token = enc
        @user.reset_password_sent_at = Time.now.utc

        @user.name = params[:topic][:user][:name]
        @user.login = params[:topic][:user][:email].split("@")[0]
        @user.email = params[:topic][:user][:email]
        @user.password = User.create_password
        built_user = true
      end

    else
      @user = current_user
      @topic.user_id = @user.id
    end

    if @user.save && @topic.save

      @post = @topic.posts.create(
        :body => params[:post][:body],
        :user_id => @user.id,
        :kind => 'first',
        :screenshots => params[:topic][:screenshots])

      if built_user == true && !user_signed_in?
        UserMailer.new_user(@user, @token).deliver_later
      end

      # track event in GA
      @tracker.event(category: 'Request', action: 'Post', label: 'New Topic')
      @tracker.event(category: 'Agent: Unassigned', action: 'New', label: @topic.to_param)

      if @topic.private?
        redirect_to params[:from] == 'widget' ? widget_thanks_path : topic_thanks_path
      else
        # redirect_to @topic.doc_id.nil? ? topic_posts_path(@topic) : doc_path(@topic.doc_id)
        redirect_to topic_posts_path(@topic)
      end
    else
      if params[:from] == 'widget'
        @widget = true
        render 'new', layout: 'widget'
      else
        render 'new'
      end
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
end
