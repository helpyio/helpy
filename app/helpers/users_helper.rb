# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string
#  identity_url           :string
#  name                   :string
#  admin                  :boolean          default(FALSE)
#  bio                    :text
#  signature              :text
#  role                   :string           default("user")
#  home_phone             :string
#  work_phone             :string
#  cell_phone             :string
#  company                :string
#  street                 :string
#  city                   :string
#  state                  :string
#  zip                    :string
#  title                  :string
#  twitter                :string
#  linkedin               :string
#  thumbnail              :string
#  medium_image           :string
#  large_image            :string
#  language               :string           default("en")
#  assigned_ticket_count  :integer          default(0)
#  topics_count           :integer          default(0)
#  active                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  provider               :string
#  uid                    :string
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  invitation_message     :text
#  time_zone              :string           default("UTC")
#  profile_image          :string
#  notify_on_private      :boolean          default(FALSE)
#  notify_on_public       :boolean          default(FALSE)
#  notify_on_reply        :boolean          default(FALSE)
#  account_number         :string
#  priority               :string           default("normal")
#

module UsersHelper

  def user_avatar(user, size=40)
    if user.thumbnail == "" && user.avatar.nil?
      user.gravatar_url(:size => 60)
    elsif user.avatar.nil? == false
      "https://res.cloudinary.com/helpy-io/image/upload/c_thumb,w_#{size},h_#{size}/#{user.avatar.path}"
    else
      user.thumbnail
    end
  end

  def avatar_image(user, size=40, font=16)
    return if user.nil?
    if user.profile_image.present?
      image_tag(user.profile_image.url, width: "#{size}px", class: 'img-circle') 
    elsif cloudinary_enabled? && user.avatar.present?
      image_tag("https://res.cloudinary.com/#{Cloudinary.config.cloud_name}/image/upload/c_thumb,w_#{size},h_#{size}/#{user.avatar.path}", width: "#{size}px", class: 'img-circle')
    elsif user.thumbnail.present?
      image_tag(user.thumbnail, width: "#{size}px", class: 'img-circle')
    else
      image_tag('', data: { name: "#{user.name}", width: "#{size}", height: "#{size}", 'font-size' => font, 'char-count' => 2}, class: 'profile img-circle')
    end

  end

end
