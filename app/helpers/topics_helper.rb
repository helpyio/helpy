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


end
