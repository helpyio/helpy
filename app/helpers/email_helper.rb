module EmailHelper
  def email_image_tag(image, **options)
    attachments[image] = File.read(Rails.root.join("app/assets/images/#{image}"))
    image_tag attachments[image].url, **options
  end

  # replace tokens with active content
  def footer_tokens(text)
    Hashid::Rails.configuration.salt=AppSettings['settings.anonymous_salt']
    text = text.gsub('%ticket_link%', "#{t('view_online', default: 'View this online:')} #{ticket_url(@topic, host: AppSettings['settings.site_url'])}")
    text = text.gsub('%anonymous_ticket_link%', "#{t('view_online', default: 'View this online:')} #{ticket_url(@topic.hashid, host: AppSettings['settings.site_url'])}")
    return text
  end

  def body_tokens(text, topic)
    return text if topic.user.nil?
    text = text.gsub('%customer_name%', topic.user.name)
    text = text.gsub('%customer_email_address', topic.user.email)
    return text
  end

  # include the ticket history in email
  def include_history?
    AppSettings['settings.include_ticket_history'] == "1"
  end

  # include the ticket body or just a link?
  def include_body?
    AppSettings['settings.include_ticket_body'] == "1"
  end

  def link_to_topic
    if AppSettings['settings.anonymous_access'] == '1'
      t('response_added', default: 'A response has been added to your ticket. Click here to see it: %{ticket_link}', 
        ticket_link: topic_url(id: @topic.hashid, host: AppSettings['settings.site_url']))
    else
      t('response_added', default: 'A response has been added to your ticket. Click here to see it: %{ticket_link}', 
        ticket_link: ticket_url(@topic, host: AppSettings['settings.site_url']))
    end
  end
end
