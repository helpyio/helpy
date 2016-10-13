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

  def i18n_reply
    # Builds the nested selector for common replies

    select = "<label class='control-label' for='post_reply_id'>#{t(:select_common, default: 'Insert Common Reply')}</label>"
    select += "<select name='post[reply_id]' class='form-control' id='post_reply_id'>"
    select += "<option value=''></option>"

    AppSettings['i18n.available_locales'].each do |locale|
      Globalize.with_locale(locale) do
        # TODO THIS IS A HACK because there appears to be no difference in language files for chinese simple and traditional
        # This could be changed to display the language names in english fairly easily
        # but in another language we are missing the translations

        if "#{locale}" == 'zh-cn' || "#{locale}" == 'zh-tw'
          select += "<optgroup label='#{I18n.translate("i18n_languages.zh")}'>"
        else
          select += "<optgroup label='#{I18n.translate("i18n_languages.#{locale}")}'>"
        end
        Doc.replies.with_translations(locale).all.each do |doc|
            body = (strip_tags(doc.body)).gsub(/\'/, '&#39;')
            select += "<option value='#{body}'>#{doc.title}</option>"
        end
        select += "</optgroup>"
      end
    end

    select += "</select>"

    # TODO: Replace this ugly string concatenation with Rails' / ActionView's "grouped_options_for_select" helper
    select.html_safe
  end

  def i18n_icons(object)
    output = '<div class="locale-badges pull-right hidden-xs hidden-sm">'
    AppSettings['i18n.available_locales'].each do |locale|
      I18n.with_locale(locale) do
        if object.translations.where(locale: locale).count > 0
          output += "<span class='badge' title='#{I18n.t(:language_name)}'>#{locale.upcase}</span></a>"
        else
          output += "<span class='badge badge-light' title='#{I18n.t(:language_name)}'>#{locale.upcase}</span></a>"
        end
      end
    end
    output += '</div>'
    output.html_safe
  end

  def select_default_locale
    tag = "<div class='form-group'>"
    tag += "<label class='control-label' for='i18n.default_locale'>#{t('default_locale', default: "Default Locale")}</label>"
    tag += "<select name='i18n.default_locale' class='form-control' id='i18n.default_locale'>"
    tag += "<option value=''>#{t('select_default_locale', default: "Select Default Locale...")}</option>"
    I18n.available_locales.sort.each do |locale|
      selected = "selected" if "#{locale}" == AppSettings['i18n.default_locale'].to_s
      I18n.with_locale(locale) do
        tag += "<option value='#{locale}' #{selected}>#{I18n.translate('language_name').mb_chars.capitalize}</option>"
      end
    end
    tag += "</select></div>"

    tag.html_safe
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
    content_tag(:li, class: 'settings-menu-item') do
      link_to(link, class: "#{settings_link(link)} #{'active-settings-link' if link == '#'}", "data-target" => title) do
        concat content_tag(:span, '', class: "#{icon} settings-menu-icon")
        concat content_tag(:span, t(title, default: title.capitalize), class: 'hidden-xs')
      end
    end
  end

  # Adds a settings-link class if no link is found.
  def settings_link(link)
    "settings-link" if link.blank? || link == '#'
  end

  def attachment_icon(filename)
    return 'fa fa-file-text-o' unless filename.include?('.')
    extension = filename.split(".").last.downcase
    case extension
      when 'pdf'
        return 'fa fa-file-pdf-o'
      when 'doc', 'docx'
        return "fa fa-file-word-o"
      when 'xls', 'xlsx'
        "fa fa-file-excel-o"
      when 'zip', 'tar'
        "fa fa-file-archive-o"
      when 'ppt', 'pptx'
        "fa fa-file-powerpoint-o"
      when 'html', 'htm'
        "fa fa-file-code-o"
      else
        "fa fa-file-o"
    end
  end

end
