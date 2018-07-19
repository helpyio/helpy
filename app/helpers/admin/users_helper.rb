module Admin::UsersHelper

  def user_header
    content_tag :h2, id: 'ticket-page-title' do
      # concat render 'admin/topics/ticket_nav_dropdown'

      # concat new_user_ticket_button
      # concat edit_user_button
      concat user_name
      concat user_account_number
    end
  end

  def new_user_ticket_button
    content_tag :span, class: "hidden-xs pull-right" do
      link_to t(:open_new_discussion, default: 'Open Discussion'), new_admin_topic_path(user_id: @user.id), remote: true, class: 'btn btn-primary'
    end
  end

  def edit_user_button
    content_tag :span, class: "edit-user hidden-xs pull-right" do
      link_to t(:edit_user, default: 'Edit User'), edit_admin_user_path(@user), remote: true, class: 'btn btn-primary'
    end
  end

  def user_name
    content_tag :span, class: 'vcenter' do
      "#{@user.name.titleize}<small>#{user_priority(@user)}</small>".html_safe
    end
  end

  def user_account_number
    content_tag :small do
      "Account: " + @user.account_number if @user.account_number.present?
    end
  end

  def priority_collection
    [[t('low_priority', default: 'Low'),'low'],[t('normal_priority', default: 'Normal'),'normal'],[t('high_priority', default: 'High'),'high'],[t('vip_priority', default: 'VIP'),'vip']]
  end

  def roles_collection
    [
      [t('admin_role'),'admin'],
      [t('agent_role'),'agent'],
      [t('editor_role'),'editor'],
      [t('user_role'),'user']
    ]
  end

end
