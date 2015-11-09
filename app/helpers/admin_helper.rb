module AdminHelper


  def assigned_to(topic)
    unless topic.assigned_user.nil?
      t(:assigned_to, agent: topic.assigned_user.name, default: "assigned to #{topic.assigned_user.name}")
    else
      t(:unassigned, default: "Unassigned")
    end
  end

  def i18n_reply

    select = "<label class='control-label' for='post_reply_id'>#{t(:select_common, default: 'Insert Common Reply')}</label>"
    select += "<select name='post[reply_id]' class='form-control' id='post_reply_id'>"
    select += "<option value=''></option>"

    I18n.available_locales.each do |locale|
      Globalize.with_locale(locale) do
        select += "<optgroup label='#{I18n.translate("language_name")}'>"
        Doc.replies.with_translations(locale).all.each do |doc|
          select += "<option value='#{doc.body}'>#{doc.title}</option>"
        end
      end
    end

    # Return select
    select.html_safe
  end

end
