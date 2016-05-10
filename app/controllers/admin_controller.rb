class AdminController < ApplicationController

  layout 'admin'

  before_action :authenticate_user!
  before_action :verify_admin
  # before_action :fetch_counts, :only => ['dashboard','tickets','ticket', 'update_ticket', 'topic_search', 'user_profile']
  # before_action :pipeline, :only => ['tickets', 'ticket', 'topic_search', 'update_ticket']
  # before_action :remote_search, :only => ['tickets', 'ticket', 'topic_search', 'update_ticket']

  def dashboard
    #@users = PgSearch.multisearch(params[:q]).page params[:page]
    @topics = Topic.mine(current_user.id).pending.page params[:page]
  end






end
