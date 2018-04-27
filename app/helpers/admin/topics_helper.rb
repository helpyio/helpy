module Admin::TopicsHelper

  def ticket_page_title
    concat j ticket_status_label
    concat j new_ticket_button
    concat j ticket_nav_dropdown
  end

  def user_page_title

  end

  def ticket_status_label
    content_tag :span, class: "label #{status_class(@status)}", style: 'text-transform: uppercase' do
      status_label(@status)
    end
  end

  def new_ticket_button
    content_tag :span, class: 'hidden-xs pull-right' do
      link_to t(:open_new_discussion, default: 'Open Discussion'), new_admin_topic_path, remote: true, class: 'btn btn-primary'
    end
  end

  def ticket_nav_dropdown
    render partial: 'admin/topics/ticket_nav_dropdown'
  end

  def user_priority(user)
    return unless user.priority?
    content_tag :span, class: 'label label-tag', style: 'text-transform: uppercase' do
      user.priority
    end
  end

end
