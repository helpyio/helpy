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
#  visibility       :string           default("all")
#

require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  should have_many(:docs)
  should validate_presence_of(:name)
  should validate_uniqueness_of(:name)
  should_not allow_value('').for(:name)
  should_not allow_value('active and featured').for(:name) #duplicate name

  test "to_param" do
    assert Category.find(1).to_param == "1-active-and-featured"
  end

  test "creating new lowercase name should be saved in sentence_case" do
    name = "something in lowercase"
    category = create :category, name: name
    assert_equal name.sentence_case, category.name
  end

  test "when creating a new category, any other capitals should be saved as entered" do
    name = "something in lowercase and UPPERCASE"
    category = create :category, name: name
    assert_equal name.sentence_case, category.name
  end

  test "deleting a category should remove all of its docs from search" do
    seed
    assert_difference 'PgSearch.multisearch("test doc").count', -2 do
      @category.destroy!
    end
  end

  test "marking a category inactive should remove all of its docs from search" do
    seed
    assert_difference 'PgSearch.multisearch("test doc").count', -2 do
      @category.update(active: false)
    end
  end

  test "marking a category internal should remove all of its docs from search" do
    seed
    assert_difference 'PgSearch.multisearch("test doc").count', -2 do
      @category.update(visibility: 'internal')
    end
  end

  def seed
    @category = Category.create!(name: "test title", active: true, visibility: 'all')
    Doc.create!(title: "test doc one", body: "some body text", category_id: @category.id)
    Doc.create!(title: "test doc two", body: "some body text", category_id: @category.id)
  end

end
