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
#

require 'test_helper'

class DocsControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  test "a browsing user should be able to show a document" do
    get :show, id: 1, locale: "en"
    assert_response :success
  end

  test "a browsing user should be able to show a document with comments" do
    get :show, id: 6, locale: "en"
    assert_response :success
  end

  test "a browsing user should be able to show a document with comments if cloudinary is configured" do

    # Make sure cloudinary cloud name is setup
    AppSettings['cloudinary.cloud_name'] = "test-cloud"
    AppSettings['cloudinary.api_key'] = "some-key"
    AppSettings['cloudinary.api_secret'] = "test-cloud"

    get :show, id: 6, locale: "en"
    assert_response :success
  end

end
