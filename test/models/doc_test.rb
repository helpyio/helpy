# == Schema Information
#
# Table name: docs
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  category_id      :integer
#  user_id          :integer
#  active           :boolean          default(TRUE)
#  rank             :integer
#  permalink        :string
#  version          :integer
#  front_page       :boolean          default(FALSE)
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'test_helper'

class DocTest < ActiveSupport::TestCase

  should belong_to(:category)
  should validate_presence_of(:title)
  should validate_presence_of(:body)
  should validate_presence_of(:category_id)

  should_not allow_value('').for(:title)

  test "should convert body to markdown" do
    assert Doc.find(3).content == "<p><em>article 3</em> text</p>\n"
  end
  
  test "to_param" do
    assert Doc.find(1).to_param == "1-article-1"
  end

end
