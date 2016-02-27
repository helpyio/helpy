class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb :root

  before_action :set_locale
  before_action :instantiate_tracker

  def url_options
    { locale: I18n.locale }.merge(super)
  end

  def after_sign_in_path_for(_resource)
    # If the user is an agent, redirect to admin panel
    redirect_url = current_user.admin? ? admin_url : root_url
    oauth_url = current_user.admin? ? admin_url : request.env['omniauth.origin']
    oauth_url || redirect_url
  end

  private

  def set_locale
    @browser_locale = http_accept_language.compatible_language_from(I18n.available_locales)
    unless params[:locale].blank?
      I18n.locale = params[:locale]
    else
      I18n.locale = @browser_locale
    end
  end

  def fetch_counts
    @new = Topic.unread.count
    @unread = Topic.unread.count
    @pending = Topic.mine(current_user.id).pending.count
    @open = Topic.open.count
    @active = Topic.active.count
    @mine = Topic.mine(current_user.id).count
    @closed = Topic.closed.count
    @spam = Topic.spam.count

    @admins = User.admins
  end

  def verify_admin
      (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.admin?)
  end

  def instantiate_tracker
    # instantiate a tracker instance for GA Measurement Protocol
    # this is used to track events happening on the server side, like email support ticket creation
    # this is stored in the session, so first lets check if its in the session

    if session[:client_id]
      logger.info("initiate tracker with client id from session")
      @tracker = Staccato.tracker(Settings.google_analytics_id, session[:client_id])
    else
      # not in the session, so check the url
      if params[:client_id]
        logger.info("initiate tracker with client id from params")
        session[:client_id] = params[:client_id]
        @tracker = Staccato.tracker(Settings.google_analytics_id, params[:client_id])
      else
        # this is a last resort and should not occur for regular web
        # visits.
        logger.info("!!! initiate tracker without client id !!!")
        @tracker = Staccato.tracker(Settings.google_analytics_id)
      end
    end
  end

end
