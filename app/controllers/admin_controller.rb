class AdminController < ApplicationController

  layout 'admin'

  before_filter :fetch_counts, :only => ['tickets','ticket']

  def index

  end

  def knowledgebase
    @categories = Category.alpha

    respond_to do |format|
      format.html { render :action => "knowledgebase" }
    end
  end

  def articles
    @category = Category.active.where(id: params[:id]).first
    @docs = @category.docs.ordered.active.page params[:page]

    respond_to do |format|
      format.html
      format.xml  { render :xml => @category }
    end
  end

  def tickets
    unless params[:status] == 'active'
      @topics = Topic.where(status: params[:status]).isprivate.page params[:page]
    else
      @topics = Topic.where(status: 'open').isprivate.page params[:page]
    end

    respond_to do |format|
      format.html
      format.js
    end

  end

  # view ticket
  def ticket

    @topic = Topic.where(id: params[:id]).first
    @topic.open if @topic.status == 'new'

    @posts = @topic.posts

    respond_to do |format|
      format.html
      format.js
    end


  end

  def update_ticket
    @topic = Topic.where(id: params[:id]).first

    @topic.status = params[:status]
    @topic.save!
    @posts = @topic.posts


    fetch_counts
    respond_to do |format|
      format.html
      format.js
    end

  end

  def community

  end

  def users

  end

  private

  def fetch_counts
    @new = Topic.where(status: 'new').isprivate.count
    @open = Topic.where(status: 'open').isprivate.count
    @closed = Topic.where(status: 'closed').isprivate.count
    @spam = Topic.where(status: 'spam').isprivate.count

    @admins = User.admins
  end


end
