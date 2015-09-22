module UsersHelper

  def user_avatar(user, size=40)
    if user.thumbnail == "" && user.avatar.nil?
      user.gravatar_url(:size => 60)
    elsif user.avatar.nil? == false
      "http://res.cloudinary.com/helpy-io/image/upload/c_thumb,w_#{size},h_#{size}/#{user.avatar.path}"
    else
      user.thumbnail
    end
  end

  def avatar_image(user, size=40)

    if user.avatar.nil? == false
      image_tag("http://res.cloudinary.com/helpy-io/image/upload/c_thumb,w_#{size},h_#{size}/#{user.avatar.path}", width: "#{size}px", class: 'img-circle')
    elsif !user.thumbnail.nil?
      image_tag(user.thumbnail, width: "#{size}px", class: 'img-circle')
    else
      image_tag('#', data: { name: "#{user.name}", width: "#{size}", height: "#{size}", 'font-size': '16', 'char-count': 2}, class: 'profile img-circle')
    end

  end

end
