module PostsHelper

  def post_message(post)

    case post.kind
    when 'first'
      message = t(:asked_a_question, user_name: post.user.name.titleize ,default: "asked a question...")
    when 'reply'
      message = t(:replied, user_name: post.user.name.titleize, default: "replied...")
    when 'note'
      message = t(:note, user_name: post.user.name.titleize, default: "posted an internal note...")
    end
    content_tag(:span, message)

  end


  def post_admin

  end

end
