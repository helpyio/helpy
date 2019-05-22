# == Schema Information
#
# Table name: notification_tokens
#
#  id           :integer          not null, primary key
#  device_key   :string
#  user_id      :integer
#  enabled      :boolean
#  device_desc  :string

class NotificationToken < ActiveRecord::Base
  belongs_to :user
  validates :device_key, uniqueness: true
  
  private
end
