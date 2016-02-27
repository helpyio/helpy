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
#

module TopicsHelper

  def badge_for_status(status)
    content_tag(:span, status_label(status).upcase, class: "hidden-xs pull-right status-label label #{status_class(status)}")
  end

  def badge_for_private
    content_tag(:span, t(:private, default: 'PRIVATE').upcase, class: 'hidden-xs pull-right status-label label label-private')
  end

  def control_for_status(status)
    content_tag(:span, "#{status_label(status).upcase} <span class='caret'></span> ".html_safe, class: "btn status-label label #{status_class(status)}")
  end

  def control_for_privacy(private_flag)
    str = private_flag ? t(:private, default: 'PRIVATE') : t(:public, default: 'PUBLIC')
    content_tag(:span, "#{str} <span class='caret'></span> ".html_safe, class: 'btn privacy-label label label-info')
  end

  def assigned_badge(topic)
    if topic.assigned_user_id.nil?
      "<span class='btn status-label label label-warning'>#{t(:unassigned, default: 'UNASSIGNED')}<span class='caret'></span> </span>"
    else
      "<span class='btn status-label label label-warning'>#{topic.assigned_user.name.upcase} <span class='caret'></span> </span>"
    end
  end

  def status_label(status)
    case status
      when 'new'
        t(:new, default: 'new')
      when 'open'
        t(:open, default: 'open')
      when 'active'
        t(:active, default: 'active')
      when 'assigned'
        t(:mine, default: 'mine')
      when 'closed'
        t(:closed, default: 'resolved')
      when 'pending'
        t(:pending, default: 'pending')
      when 'spam'
        t(:spam, default: 'spam')
      when 'trash'
        t(:trash, default: 'trash')
    end
  end

  def status_class(status)
    case status
      when 'new'
        'label-info'
      when 'open'
        'label-success'
      when 'closed'
        'label-default'
      when 'pending'
        'label-warning'
      when 'spam'
        'label-danger'
      when 'trash'
        'label-danger'
    end
  end


end
