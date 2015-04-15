module TopicsHelper

  def badge_for_status(status)

    case status
      when 'new'
        class_name = 'label-info'
      when 'open'
        class_name = 'label-success'
      when 'closed'
        class_name = 'label-default'
    end

    "<span class='status-label label #{class_name}'>#{status.upcase}</span>"
  end

  def control_for_status(status)

    case status
      when 'new'
        class_name = 'label-info'
      when 'open'
        class_name = 'label-success'
      when 'closed'
        class_name = 'label-default'
    end

    "<span class='status-label label #{class_name}'>#{status.upcase} <span class='caret'></span> </span>"
  end

  def assigned_badge(topic)
    if topic.assigned_user_id.nil?
      "<span class='status-label label label-warning'>UNASSIGNED <span class='caret'></span> </span>"
    else
      "<span class='status-label label label-warning'>Assigned to #{topic.assigned_user.name.upcase} <span class='caret'></span> </span>"
    end
  end

end
