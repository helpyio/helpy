module SearchConcern
  extend ActiveSupport::Concern

  protected

  def search_topics
    if @start_date.present? && @end_date.present?
      topics_to_search = Topic.where('created_at >= ?', @start_date).where('created_at <= ?', @end_date)
    else
      topics_to_search = Topic.all
    end
    if current_user.is_restricted? && teams?
      @topics = topics_to_search.admin_search(params[:q]).tagged_with(current_user.team_list, :any => true).page params[:page]
    else
      @topics = topics_to_search.admin_search(params[:q]).page params[:page]
    end
  end

  def search_date_from_params
    @start_date = params[:start_date].to_datetime if params[:start_date].present?
    @end_date = params[:end_date].to_datetime if params[:end_date].present?
  end


end