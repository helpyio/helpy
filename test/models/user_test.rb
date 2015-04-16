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
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
