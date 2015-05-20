# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  should have_many(:docs)
  should validate_presence_of(:name)
  should_not allow_value('').for(:name)
  should_not allow_value('active and featured').for(:name) #duplicate name

  test "to_param" do
    assert Category.find(1).to_param == "1-active-and-featured"
  end

end
