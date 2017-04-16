module Admin::ReportsHelper

  def assigned_agent_stats(scoped_stats)
    User.agents.map { |a| [ a.name, scoped_stats.where(assigned_user_id: a.id).count] }
  end

  def tickets_by_status(scoped_stats)
    scoped_stats.group(:current_status).count
  end

  def tickets_by_group(scoped_stats)
    team_tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "teams").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    @teams = ActsAsTaggableOn::Tag.where("id IN (?)", team_tag_ids)
    @teams.order('name asc').map { |g| [g.name, scoped_stats.tagged_with(g.name).count] }
  end

  def group_colors(scoped_stats)
    team_tag_ids = ActsAsTaggableOn::Tagging.all.where(context: "teams").includes(:tag).map{|tagging| tagging.tag.id }.uniq
    @teams = ActsAsTaggableOn::Tag.where("id IN (?)", team_tag_ids)
    @teams.map { |g| g.color }
  end

end
