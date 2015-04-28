module PostsHelper

  def post_message(kind)

    case kind
    when 'first'
      message = t(:asked_a_question, default: "asked a question...")
    when 'reply'
      message = t(:replied, default: "replied...")
    when 'note'
      message = t(:note, default: "posted an internal note...")
    end

    content_tag(:span, message)

  end

end
