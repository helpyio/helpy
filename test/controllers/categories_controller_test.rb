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

class CategoriesControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a browsing user in the default locale should be able to load the index and see categories" do
    get :index, locale: :en
    assert_response :success

    # Should see at least once category
    assert_select "a#category-1", true

    # should be able to see Documents
    assert_select "li.article", true
  end

  test "a browsing user in a locale without translations should be able to load the index and should see no categories" do
    get :index, locale: :fr
    assert_response :success

    # Make sure nothing here message shown
    assert_select "div.nothing-in-locale", true
  end

  test "a browsing user in the default locale should be able to see a category page" do
    get :show, id: 1, locale: :en
    assert_response :success

    # should be able to see Documents
    assert_select "li.article", true
  end
end
