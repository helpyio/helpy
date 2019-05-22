module SearchConcern
  extend ActiveSupport::Concern

  protected

  def search_topics
    topics_to_search = Topic.where('created_at >= ?', @start_date).where('created_at <= ?', @end_date)
    if current_user.is_restricted? && teams?
      @topics = topics_to_search.admin_search(params[:q]).tagged_with(current_user.team_list, :any => true).page params[:page]
    else
      @topics = topics_to_search.admin_search(params[:q]).page params[:page]
    end
  end

  def search_date_from_params
    if params[:start_date].present?
      @start_date = params[:start_date].to_datetime
    else
      @start_date = Time.zone.today-1.month
    end

    if params[:end_date].present?
      @end_date = params[:end_date].to_datetime
    else
      @end_date = Time.zone.today.at_end_of_day
    end
  end


end