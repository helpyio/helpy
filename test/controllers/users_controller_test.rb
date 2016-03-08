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
#

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  setup do
    I18n.available_locales = [:en, :fr, :et]
    I18n.locale = :en
  end

  # browsers

  test "a browser should NOT be able to view edit profile page" do
    get :edit, id: 2, locale: :en
    assert_redirected_to new_user_session_path
  end

  # admins


  test "an admin should be able to update a user" do
    sign_in users(:admin)
    assert_difference('User.find(2).name.length',-3) do
      patch :update, { id: 2, user: {name: 'something', email:'scott.miller@test.com'}, locale: :en }
    end
    assert User.find(2).name == 'something', "name does not update"
  end

  test "an admin should be able to update a user and make them an admin" do
    sign_in users(:admin)
    assert_difference('User.admins.count',1) do
      patch :update, { id: 2, user: {name: 'something', email:'scott.miller@test.com', admin: true}, locale: :en }
    end
  end

end
