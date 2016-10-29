# == Schema Information
#
# Table name: images
#
#  id         :integer          not null, primary key
#  key        :string
#  name       :string
#  extension  :string
#  file       :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Image < ActiveRecord::Base

  mount_uploader :file, ImageUploader

end
