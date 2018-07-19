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

require 'test_helper'

class ImageTest < ActiveSupport::TestCase
end
