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
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)
#  attachments      :string           default([]), is an Array
#

require 'test_helper'

class DocTest < ActiveSupport::TestCase

  should belong_to(:category)
  should have_one(:topic)
  should have_many(:posts)
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

  test "creating new lowercase title should be saved in sentence_case" do
    title = "something in lowercase"
    doc = create :doc, title: title
    assert_equal title.sentence_case, doc.title
  end

  test "when creating a new doc, any other capitals should be saved as entered" do
    title = "something in lowercase and UPPERCASE"
    doc = create :doc, title: title
    assert_equal title.sentence_case, doc.title
  end

  test "deleting a doc should remove it from search" do
    seed
    assert_difference 'PgSearch.multisearch("test doc").count', -1 do
      @doc.destroy!
    end
  end

  test "a draft doc should not be in search" do
    seed
    assert_difference 'PgSearch.multisearch("test doc").count', -1 do
      @doc.update(active: false)
    end
  end

  def seed
    @category = Category.create!(name: "test title", active: true, visibility: 'all')
    Doc.create!(title: "test doc one", body: "some body text", category_id: @category.id)
    @doc = Doc.create!(title: "test doc two", body: "some body text", category_id: @category.id)
  end

end
