module AdminHelper


  def assigned_to(topic)
    unless topic.assigned_user.nil?
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

    I18n.available_locales.each do |locale|
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
          select += "<option value='#{doc.body}'>#{doc.title}</option>"
        end
        select += "</optgroup>"
      end
    end

    select += "</select>"

    # Return select
    select.html_safe
  end

end
