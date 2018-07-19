module AdminHelper

  include StatsHelper
  def assigned_to(topic)
    if topic.assigned_user.present?
      t(:assigned_to, agent: topic.assigned_user.name, default: "assigned to #{topic.assigned_user.name}")
    else
      t(:unassigned, default: "Unassigned")
    end
  end

  def admin_title
    "[Helpy Admin]"
  end

  def upper_nav_item(label, path, controllers, actions, icon="")
    # classname = controller_name == controller ? 'navbar-active' : ''
    if controllers.include?(controller_name) && actions.include?(action_name)
      classname = 'navbar-active'
    else
      classname = ''
    end

    content_tag(:li, class: classname) do
      link_to path, class: 'text-center' do
        "#{content_tag(:span, nil, class: "#{icon}")}<br/>#{label}".html_safe
      end
    end
  end

  def i18n_reply_grouped_options
    grouped_options = {}
    AppSettings['i18n.available_locales'].each do |locale|
      Globalize.with_locale(locale) do
        # TODO THIS IS A HACK because there appears to be no difference in language files for chinese simple and traditional
        # This could be changed to display the language names in english fairly easily
        # but in another language we are missing the translations

        key = if ['zh-cn', 'zh-tw'].include? locale
                I18n.translate("i18n_languages.zh")
              else
                I18n.translate("i18n_languages.#{locale}")
              end
        val = []
        Doc.replies.with_translations(locale).all.each do |doc|
            body = ((doc.body))#.gsub(/\'/, '&#39;')
            val.push([doc.title, body])
        end
        grouped_options[key] = val
      end
    end
    grouped_options
  end

  def i18n_icons(object)
    output = '<div class="locale-badges pull-right hidden-xs hidden-sm">'
    AppSettings['i18n.available_locales'].each do |locale|
      I18n.with_locale(locale) do
        if object.translations.where(locale: locale).count > 0
          output += "<span class='badge' title='#{I18n.t(:language_name)}'>#{locale}</span></a>"
        else
          output += "<span class='badge badge-light' title='#{I18n.t(:language_name)}'>#{locale}</span></a>"
        end
      end
    end
    output += '</div>'
    output.html_safe
  end

  def new_active_class
    if controller_name == "topics" && action_name == "new"
      'navbar-active'
    else
      ''
    end
  end

  def default_locale_options
    options = {}
    options[t('select_default_locale', default: "Select Default Locale...")] = ''
    I18n.available_locales.sort.each do |locale|
      I18n.with_locale(locale) do
        options[I18n.translate('language_name').mb_chars.capitalize] = locale
      end
    end
    options_for_select(options, AppSettings['i18n.default_locale'].to_s )
  end

  def navbar_expanding_link(url, icon, text, target="", remote=false)
    link_to url, remote: remote, target: target do
      content_tag(:span, '', class: "#{icon} hidden-lg hidden-md", title: text) + content_tag(:span, text, class: "hidden-sm hidden-xs")
    end
  end

  def settings_item(icon, title, description, link = "")
    content_tag(:div, class: 'col-md-6 col-sm-6 settings-grid-block') do
      content_tag(:div, class: 'media') do
        concat content_tag(:div, content_tag(:span, '', class: "#{icon} settings-icon"), class: 'pull-left')
        concat settings_blurb(title, description, link)
      end
    end
  end

  def settings_blurb(title, description, link = "#")
    content_tag(:div, class: 'media-body') do
      concat content_tag(:h4, settings_title_link(title, link), class: "#{settings_link(link)} more-important media-heading")
      concat content_tag(:p, "#{description}", class: 'less-important')
    end
  end

  def settings_title_link(title, link = "#")
      link_to t(title.to_sym, default: "#{title.capitalize}"), link, class: "#{settings_link(link)} active-settings-link", "data-target" => "#{title}"
  end

  def settings_menu_item(icon, title, link='#')
    content_tag(:li, class: 'nav-item') do
      link_to(link, class: "#{settings_link(link)} #{'active-settings-link' if current_page?(link)}", "data-target" => title) do
        # concat content_tag(:span, '', class: "#{icon} settings-menu-icon")
        concat content_tag(:span, t(title, default: title.capitalize))
      end
    end
  end

  def help_menu
    content_tag :li, class: 'dropdown pull-left', role: 'presentation' do
      concat help_link
      concat help_items
    end
  end

  def help_link
    link_to '#', class: 'dropdown-toggle', data: { toggle: 'dropdown' } do
      concat t(:get_help, default: 'Help')
      concat content_tag(:span, '', class: 'caret')
    end
  end

  def help_items
    content_tag :ul, class: 'dropdown-menu' do
      concat content_tag(:li, link_to(t(:get_help, default: "Get Help"), "http://support.helpy.io/"), target: "blank")
      concat content_tag(:li, link_to(t(:internal_content, default: "Internal Content"), admin_internal_categories_path), class:'kblink') if knowledgebase?
      concat content_tag(:li, link_to(t(:report_bug, default: "Report a Bug"), "http://github.com/helpyio/helpy/issues"), target: "blank")
      concat content_tag(:li, link_to(t(:suggest_feature, default: "Suggest a Feature"), "http://support.helpy.io/en/community/4-feature-requests/topics"), target: "blank")
      concat content_tag(:li, link_to(t(:shortcuts, default: "Keyboard Shortcuts"), "#", class: 'keyboard-shortcuts-link'), target: "blank") if current_user.is_agent?
      concat content_tag :hr
      concat content_tag(:li, link_to("Sponsors", "https://helpy.io/sponsors", target: 'blank'))
    end
  end

  def helpcenter_menu
    content_tag :li, class: 'dropdown' do
      concat helpcenter_link
      concat helpcenter_items
    end
  end

  def helpcenter_link
    link_to '#', class: 'dropdown-toggle text-center', data: { toggle: 'dropdown' }, role: 'button' do
      concat "#{content_tag :span, nil, class: 'fas fa-book'}<br/>#{t(:helpcenter, default: 'Helpcenter')}".html_safe
      concat content_tag(:span, '', class: 'caret')
    end
  end

  def helpcenter_items
    content_tag :ul, class: 'dropdown-menu' do
      concat content_tag(:li, link_to(t(:content, default: "Content"), admin_categories_path), class:'kblink') if knowledgebase? && current_user.is_editor?
      concat content_tag(:li, link_to(t(:communities, default: "Communities"), admin_forums_path)) if forums? && current_user.is_agent?
    end
  end

  def admin_avatar_menu
    content_tag :li, class: 'dropdown visible-lg visible-md visible-sm hidden-xs', role: 'presentation' do
      concat admin_avatar_menu_link
      concat admin_avatar_menu_items
    end
  end

  def admin_avatar_menu_link
    link_to '#', class: 'dropdown-toggle', data: { toggle: 'dropdown' } do
      concat content_tag(:span, avatar_image(current_user, size=25, font=10) + current_user.name, class: 'admin-avatar')
      concat content_tag(:span, '', class: 'caret')
    end
  end

  def admin_avatar_menu_items
    content_tag :ul, class: 'dropdown-menu' do
      concat content_tag(:li, link_to(t(:your_profile, default: 'Your Profile'), admin_profile_settings_path(mode: 'settings')), class: 'visible-lg visible-md visible-sm hidden-xs')
      concat content_tag(:li, link_to(t(:settings, default: 'Settings'), admin_general_settings_path), class: 'visible-lg visible-md visible-sm hidden-xs') if current_user.is_admin?


      concat content_tag(:li, link_to(t('api_keys', default: "API Keys"), admin_api_keys_path), class: 'visible-lg visible-md visible-sm hidden-xs') if current_user.is_agent?
      concat content_tag(:li, link_to(t(:logout, default: "Logout"), destroy_user_session_path), class: 'visible-lg visible-md visible-sm hidden-xs')
    end
  end

  # Adds a settings-link class if no link is found.
  def settings_link(link)
    "settings-link" if link.blank? || link == '#'
  end

  def attachment_icon(filename)
    return 'far fa-file-text' unless filename.include?('.')
    extension = filename.split(".").last.downcase
    case extension
      when 'pdf'
        return 'far fa-file-pdf'
      when 'doc', 'docx'
        return "far fa-file-word"
      when 'xls', 'xlsx'
        "far fa-file-excel"
      when 'zip', 'tar'
        "far fa-file-archive"
      when 'ppt', 'pptx'
        "far fa-file-powerpoint"
      when 'html', 'htm'
        "far fa-file-code"
      else
        "far fa-file"
    end
  end

  def user_page_title_text(role)
    case role
      when 'user'
        "#{t(:user_role).pluralize(2)}"
      when 'agent'
        "#{t(:agent_role).pluralize(2)}"
      when 'editor'
        "#{t(:editor_role).pluralize(2)}"
      when 'admin'
        "#{t(:admin_role).pluralize(2)}"
      when 'team'
        "Team"
      else
        "#{t(:users)}"
    end

  end


  def user_filter
    content_tag :span, class: 'btn-group' do
      concat user_filter_select
      concat user_filter_options
    end
  end

  def user_filter_select
    content_tag :button, class: 'btn btn-default dropdown-toggle', data: { toggle: 'dropdown' } do
      content_tag :span, class: 'btn' do
        ("Filter " + icon('caret-down')).html_safe
      end
    end
  end

  def user_filter_options
    content_tag :ul, class: 'dropdown-menu', role: 'menu' do
      @roles.each do |u|
        concat content_tag :li, link_to(u[0], admin_users_path(role: u[1]))
      end
    end
  end

  def admin_teams
    ActsAsTaggableOn::Tagging.all.where(context: "teams").includes(:tag).where("context = 'teams' and tags.show_on_admin = ?", 'true').references(:tags).map{|tagging| tagging.tag.name.capitalize }.uniq
  end

  def formatted_tags(topic)
    content_tag :ul, class: 'list-horizontal topic-tag-list', style: 'padding-left: 0; padding-top: 3px;' do
      list_tags(topic)
    end
  end

  def list_tags(topic)
    topic.tag_list.each do |tag|
      concat content_tag(:li, "#{tag}", class: 'label label-tag topic-tag', style: 'margin-right:3px;')
    end
  end

  def add_tag_link
    content_tag :li do
      content_tag(:span, '', class: 'fas fa-tag add-tag-link')
    end
  end

  def inbound_group_email(group, from_email)
    "#{from_email.split('@')[0]}+#{group}@#{from_email.split('@')[1]}" if group.present? && from_email.present?
  end

end
