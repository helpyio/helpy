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

end
