module Admin::TopicsHelper

  def ticket_page_title
    concat j ticket_status_label
    concat j new_ticket_button
    concat j ticket_nav_dropdown
  end

  def user_page_title

  end

  def started_by(topic)
    return "Missing User" if topic.user.nil?
    user_name = topic.user.name
    link_to t(:started_by, username: user_name.titleize, default: "Started by #{user_name}"), admin_user_path(topic.user.id), remote: true
  end

  def topic_added_from
    content_tag :small, class: 'less-important hidden-xs' do
      concat t(:topic_added_from, kind: @topic.kind, channel: @topic.channel)
      concat ": #{link_to(@doc.title, edit_admin_category_doc_path(@doc.category_id, @doc.id, lang: I18n.locale))}".html_safe if @doc.present?
    end
  end

  def topic_anonymous_link
    content_tag :div, class: 'pull-right' do
      content_tag :small, class: 'less-important anonymous-link' do
        link_to topic_path(id: @topic.hashid), target: 'blank' do
          content_tag :i, nil, class: 'fas fa-link' 
        end
      end 
    end if AppSettings['settings.anonymous_access'] == "1"
  end

  def ticket_status_label
    content_tag :span, class: "label #{status_class(@status)}", style: 'text-transform: uppercase' do
      status_label(@status)
    end
  end

  def new_ticket_button
    content_tag :span, class: 'hidden-xs pull-right' do
      link_to t(:open_new_discussion, default: 'Open Discussion'), new_admin_topic_path, remote: true, class: 'btn btn-primary' if tickets?
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

  def ticket_tag_collection
    ActsAsTaggableOn::Tagging.all.where(context: "tags", taggable_type: 'Topic').includes(:tag).map{|tagging| tagging.tag.name }.uniq.sort
  end

  # id of opening or first post in the topic
  def first_post_id(topic)
    first_post = topic.posts.order(created_at: :asc).first
    first_post.present? ? first_post.id : nil
  end

  # show topic tag form
  def topic_tag_form
    return nil if ticket_tag_collection.blank?
    simple_form_for @topic, url: admin_update_topic_tags_path(id: @topic.id, status: params[:status]), remote: true, html: { class: 'form-inline tag-form' } do |f|
      content_tag :div, class: 'row' do
        content_tag :div, class: 'col-md-8' do
          f.input :tag_list, collection: ticket_tag_collection, 
            as: :select, include_blank: false, label: false,
            input_html: { multiple: true, class: '', placeholder: 'click to add tags...' },
            # wrapper_html: { style: 'width: 0' }, 
            data: { 'none-selected-text': t('tag_with', default: 'Tag Ticket'), 'live-search': false, 'width': '150px', dropdownAlignRight: false },
            style: 'width: 280px;'
            
        end
      end
    end
  end

  # tag button label
  def tags_button_label
    if @topic.tag_list.count > 0
      pluralize @topic.tag_list.count, "Tag"
    else
      t(:tag_with, default: "Tag Ticket")
    end
  end

end
