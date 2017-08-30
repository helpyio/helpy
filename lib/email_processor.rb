class EmailProcessor

  def initialize(email)
    @email = email
  end

  def process

    # Create email JSON object to hand off to background job
    email = {
                body: @email.body.encode('utf-8', invalid: :replace, replace: '?'),
                raw_text: @email.raw_text.encode('utf-8', invalid: :replace, replace: '?'),
                raw_html: @email.raw_html.encode('utf-8', invalid: :replace, replace: '?'),
                from: @email.from,
                subject: @email.subject,
                to: @email.to,
                cc: @email.cc
            }

    # Add attachments if their are any
    if @email.attachments.present?
      email[:attachments] = @email.attachments.map {|att| {
          type: att.content_type,
          name: att.original_filename.include?('=?UTF-8?') ? "unknown#{Rack::Mime::MIME_TYPES.invert[att.content_type]}" : att.original_filename,
          path: att.tempfile.path
          }}
    end
    ReceiveEmailJob.perform_later(email, AppSettings["settings.site_name"],google_analytics_enabled?, cloudinary_enabled?, AppSettings['cloudinary.cloud_name'], AppSettings['cloudinary.api_key'], AppSettings['cloudinary.api_secret'])

  end

  def cloudinary_enabled?
    AppSettings['cloudinary.cloud_name'].present? && AppSettings['cloudinary.api_key'].present? && AppSettings['cloudinary.api_secret'].present? && AppSettings['cloudinary.enabled'] != '0'
  end

  def google_analytics_enabled?
    AppSettings['settings.google_analytics_enabled'] == '1'
  end

  def handle_attachments(email, post)
    return unless email.attachments.present?

    if cloudinary_enabled?
      email.attachments.each {|t| ObjectSpace.undefine_finalizer(t.tempfile)}
      email = {
                  attachments: @email.attachments.map {|att| {
                      type: att.content_type,
                      name: att.original_filename.include?('=?UTF-8?') ? "unknown#{Rack::Mime::MIME_TYPES.invert[att.content_type]}" : att.original_filename,
                      path: att.tempfile.path
                  }},
                  raw_text: @email.raw_text.encode('utf-8', invalid: :replace, replace: '?'),
                  raw_html: @email.raw_html.encode('utf-8', invalid: :replace, replace: '?'),
                  from: @email.from,
                  subject: @email.subject,
                  to: @email.to,
                  cc: @email.cc
              }

      AttachmentJob.perform_in(1.minute, email, post.id, AppSettings['cloudinary.cloud_name'], AppSettings['cloudinary.api_key'], AppSettings['cloudinary.api_secret'] )
    else
      post.update(
        attachments: email.attachments
      )
      if post.valid?
        post.save
      end
    end
  end

end
