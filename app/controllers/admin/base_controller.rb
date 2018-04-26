class Admin::BaseController < ApplicationController

  layout 'admin'
  before_action :authenticate_user!

  def convert_to_brightness_value(background_hex_color)
    (background_hex_color.scan(/../).map {|color| color.hex}).sum
  end

  def contrasting_text_color(background_hex_color)
    convert_to_brightness_value(background_hex_color) > 382.5 ? '#000' : '#fff'
  end
  helper_method :contrasting_text_color

  def lighten_color(hex_color, amount=0.6)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = [(rgb[0].to_i + 255 * amount).round, 255].min
    rgb[1] = [(rgb[1].to_i + 255 * amount).round, 255].min
    rgb[2] = [(rgb[2].to_i + 255 * amount).round, 255].min
    "#%02x%02x%02x" % rgb
  end
  helper_method :lighten_color

  def darken_color(hex_color, amount=0.4)
    hex_color = hex_color.gsub('#','')
    rgb = hex_color.scan(/../).map {|color| color.hex}
    rgb[0] = (rgb[0].to_i * amount).round
    rgb[1] = (rgb[1].to_i * amount).round
    rgb[2] = (rgb[2].to_i * amount).round
    "#%02x%02x%02x" % rgb
  end
  helper_method :darken_color

  protected

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

  def remote_search
    @remote_search = true
  end

  def check_current_user_is_allowed? topic
    return true if !topic.private || current_user.is_admin? || current_user.team_list.include?(topic.team_list.first)
    if topic.team_list.count > 0 && current_user.is_restricted? && (topic.team_list + current_user.team_list).count > 0
      false
    else
      true
    end
  end

  def date_from_params
    if params[:start_date].present?
      @start_date = params[:start_date].to_datetime
    else
      @start_date = Time.zone.today.at_beginning_of_week
    end

    if params[:end_date].present?
      @end_date = params[:end_date].to_datetime
    else
      @end_date = Time.zone.today.at_end_of_day
    end
  end

  # Get a list of topics for a passed in status
  # Used by topics#index and #show and called from other methods that need to
  # refresh the UI
  def get_tickets_by_status
    @status = params[:status] || "active"
    if current_user.is_restricted? && teams?
      topics_raw = Topic.all.tagged_with(current_user.team_list, any: true)
    else
      topics_raw = params[:team].present? ? Topic.all.tagged_with(params[:team], any: true) : Topic
    end
    topics_raw = topics_raw.includes(user: :avatar_files).chronologic

    get_all_teams

    case @status
    when 'new'
      topics_raw = topics_raw.unread
    when 'active'
      topics_raw = topics_raw.active
    when 'mine'
      topics_raw = Topic.active.mine(current_user.id).chronologic
    when 'pending'
      topics_raw = Topic.pending.mine(current_user.id).chronologic
    else
      topics_raw = topics_raw.where(current_status: @status)
    end
    @topics = topics_raw.page params[:page]
  end


  def fetch_counts
    if current_user.is_restricted? && teams?
      topics = Topic.tagged_with(current_user.team_list, :any => true)
      @admins = User.agents #can_receive_ticket.tagged_with(current_user.team_list, :any => true)
    else
      topics = Topic.all
      @admins = User.agents.includes(:topics)
    end
    @new = topics.unread.count
    @unread = topics.unread.count
    @pending = Topic.mine(current_user.id).pending.count
    @open = topics.open.count
    @active = topics.active.count
    @mine = Topic.active.mine(current_user.id).count
    # @closed = topics.closed.count
    # @spam = topics.spam.count
  end

  def set_categories_and_non_featured
    @public_categories = Category.publicly.featured.ordered
    @public_nonfeatured_categories = Category.publicly.unfeatured.alpha
    @internal_categories = Category.only_internally.ordered
  end

end
