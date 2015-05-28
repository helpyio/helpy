module PostsHelper

  def post_message(post)

    case post.kind
    when 'first'
      message = t(:asked_a_question, user_name: post.user.name.titleize ,default: "asked a question...")
    when 'reply'
      message = t(:replied, user_name: post.user.name.titleize, default: "replied...")
    when 'note'
      message = t(:posted_note, user_name: post.user.name.titleize, default: "posted an internal note...")
    end
    if user_signed_in? && current_user.admin? && params[:controller] == 'admin'
      content_tag(:span, class: 'btn dropdown-toggle more-important', data: { toggle: 'dropdown'}, aria: {expanded: 'false'}) do
        "#{message} <span class='caret'></span>".html_safe
      end
    else
      content_tag(:span, class: 'more-important') do
        "#{message}".html_safe
      end
    end
  end


  def post_admin

  end

end
