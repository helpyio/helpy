class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  add_breadcrumb :root

  before_action :set_locale
  before_action :set_vars
  before_action :instantiate_tracker

  def url_options
    { locale: I18n.locale }.merge(super)
  end

  def after_sign_in_path_for(_resource)
    # If the user is an agent, redirect to admin panel
    redirect_url = current_user.is_agent? ? admin_root_url : root_url
    oauth_url = current_user.is_agent? ? admin_root_url : request.env['omniauth.origin']
    oauth_url || redirect_url
  end

  # These 3 methods provide feature authorization for admins. Editor is the most restricted,
  # agent is next and admin has access to everything:

  def verify_editor
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_editor?)
  end

  def verify_agent
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_agent?)
  end

  def verify_admin
    (current_user.nil?) ? redirect_to(root_path) : (redirect_to(root_path) unless current_user.is_admin?)
  end

  private

  def set_locale
    @browser_locale = http_accept_language.compatible_language_from(AppSettings['i18n.available_locales'])
    unless params[:locale].blank?
      I18n.locale = AppSettings['i18n.available_locales'].include?(params[:locale]) ? params[:locale] : AppSettings['i18n.default_locale']
    else
      I18n.locale = @browser_locale
    end
  end

  def set_vars
    # Configure griddler, mailer
    Griddler.configuration.email_service = AppSettings["email.mail_service"].to_sym

    ActionMailer::Base.smtp_settings = {
        :address   => AppSettings["email.mail_smtp"],
        :port      => AppSettings["email.mail_port"],
        :user_name => AppSettings["email.smtp_mail_username"],
        :password  => AppSettings["email.smtp_mail_password"],
        :domain    => AppSettings["email.mail_domain"]
    }

    ActionMailer::Base.perform_deliveries = to_boolean(AppSettings['email.send_email'])

    Cloudinary.config do |config|
      config.cloud_name = AppSettings['cloudinary.cloud_name'].blank? ? nil : AppSettings['cloudinary.cloud_name']
      config.api_key = AppSettings['cloudinary.api_key'].blank? ? nil : AppSettings['cloudinary.api_key']
      config.api_secret = AppSettings['cloudinary.api_secret'].blank? ? nil : AppSettings['cloudinary.api_secret']
    end

  rescue
    logger.warn("WARNING!!! Error setting configs.")
    if AppSettings['email.mail_service'] == 'mailin'
      AppSettings['email.mail_service'] == ''
    end
  end

  def to_boolean(str)
    str == 'true'
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

    @admins = User.agents
  end

  def instantiate_tracker
    # instantiate a tracker instance for GA Measurement Protocol
    # this is used to track events happening on the server side, like email support ticket creation
    # this is stored in the session, so first lets check if its in the session

    if session[:client_id]
      logger.info("initiate tracker with client id from session")
      @tracker = Staccato.tracker(AppSettings['settings.google_analytics_id'], session[:client_id])
    else
      # not in the session, so check the url
      if params[:client_id]
        logger.info("initiate tracker with client id from params")
        session[:client_id] = params[:client_id]
        @tracker = Staccato.tracker(AppSettings['settings.google_analytics_id'], params[:client_id])
      else
        # this is a last resort and should not occur for regular web
        # visits.
        logger.info("!!! initiate tracker without client id !!!")
        @tracker = Staccato.tracker(AppSettings['settings.google_analytics_id'])
      end
    end
  end

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

end
