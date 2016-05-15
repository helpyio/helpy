module AdminHelper
  def assigned_to(topic)
    if topic.assigned_user.present?
      t(:assigned_to, agent: topic.assigned_user.name, default: "assigned to #{topic.assigned_user.name}")
    else
      t(:unassigned, default: "Unassigned")
    end
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
          select += "<option value='#{strip_tags(doc.body)}'>#{doc.title}</option>"
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
    tag += "<label class='control-label' for='i18n.default_locale'>Default Locale</label>"
    tag += "<select name='i18n.default_locale' class='form-control' id='i18n.default_locale'>"
    tag += "<option value=''>Select Default Locale...</option>"
    I18n.available_locales.sort.each do |locale|
      selected = "selected" if "#{locale}" == AppSettings['i18n.default_locale'].to_s
      I18n.with_locale(locale) do
        tag += "<option value='#{locale}' #{selected}>#{I18n.translate('language_name').mb_chars.capitalize}</option>"
      end
    end
    tag += "</select></div>"

    tag.html_safe
  end

  def settings_item(icon, title, description)
    content_tag(:div, class: 'col-md-6 col-sm-6 settings-grid-block') do
      content_tag(:div, class: 'media') do
        concat content_tag(:div, content_tag(:span, '', class: "#{icon} settings-icon"), class: 'pull-left')
        concat settings_blurb(title, description)
      end
    end
  end

  def settings_blurb(title, description)
    content_tag(:div, class: 'media-body') do
      concat content_tag(:h4, settings_title_link(title), class: 'settings-link more-important media-heading')
      concat content_tag(:p, "#{description}", class: 'less-important')
    end
  end

  def settings_title_link(title)
    link_to t(title.to_sym, default: "#{title.capitalize}"), '#', class: 'settings-link active-settings-link', "data-target" => "#{title}"
  end

  def settings_menu_item(icon, title)
    content_tag(:li, class: 'settings-menu-item') do
      link_to('#', class: 'settings-link active-settings-link', "data-target" => title) do
        concat content_tag(:span, '', class: "#{icon} settings-menu-icon")
        concat content_tag(:span, t(title, default: title.capitalize), class: 'hidden-xs')
      end
    end
  end

end
