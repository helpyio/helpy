module Admin::ReportsHelper

  def assigned_agent_stats(scoped_stats)
    User.agents.map { |a| [ a.name, scoped_stats.where(assigned_user_id: a.id).count] }
  end

  def tickets_by_status(scoped_stats)
    scoped_stats.group(:current_status).count
  end

  def tickets_by_group(scoped_stats)
    @teams = @all_teams.sort_by!{ |e| ActiveSupport::Inflector.transliterate(e.downcase) }.map { |name| [name, scoped_stats.tagged_with(name).count] }
  end

  def percent_resolved(fraction, total, default=0)
    total > 0 ? number_to_percentage((fraction.to_f/total.to_f)*100, precision: 0) : number_to_percentage(default, precision: 0)
  end

  def per_day(number, days, default=0)
    if days == 0
      "-"
    else
      (number.to_f/days.to_f).round(1)
    end
  end

  # NOTE Does not appear to be used currently.  Needs work to return the color.
  def group_colors(scoped_stats)
    # team_tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "teams").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    # @teams = ActsAsTaggableOn::Tag.where("id IN (?)", team_tag_ids)
    @all_teams.map { |g| g.color }
  end

end
