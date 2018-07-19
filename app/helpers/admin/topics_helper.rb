module Admin::TopicsHelper

  def ticket_page_title
    concat j ticket_status_label
    concat j new_ticket_button
    concat j ticket_nav_dropdown
  end

  def user_page_title

  end

  def topic_added_from
    # <span class="less-important" style="font-size: 12px;"><%= "#{@topic.kind} added from #{@topic.channel}" %><%= " on #{link_to(@doc.title, edit_admin_category_doc_path(@doc.category_id, @doc.id, lang: I18n.locale))}".html_safe if @doc.present? %></span>
    content_tag :small, class: 'less-important' do
      concat t(:topic_added_from, kind: @topic.kind, channel: @topic.channel)
      concat ": #{link_to(@doc.title, edit_admin_category_doc_path(@doc.category_id, @doc.id, lang: I18n.locale))}".html_safe if @doc.present?
    end
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

  def agents_for_select
    User.agents.all.map { |user| [user.name, user.id] }
  end

  def channels_collection
    [
      [t('activerecord.attributes.user.email'), 'email'],
      [t('activerecord.attributes.user.home_phone'), 'phone'],
      [t(:channel_in_person, default: 'In Person'), 'person']
    ]
  end

  def statuses_collection
    statuses = []
    ['new','open','pending','closed'].each do |s|
      statuses << [t(s.to_sym), s]
    end
    statuses
  end

  def ticket_types_collection
    [
      [t('customer_conversation', default: "Customer Conversation"), 'ticket'],
      [t('internal_ticket', default: "Internal Ticket"), 'internal']
    ]
  end

  def ticket_priority_collection
    Topic.priorities.keys.map { |priority| [t("#{priority}_priority"), priority] }
  end

end
