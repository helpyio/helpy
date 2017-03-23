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

class Admin::UsersControllerTest < ActionController::TestCase

  setup do
    set_default_settings
  end

  def file
    @file ||= File.open(File.expand_path( '../logo.png', __FILE__))
  end

  def uploaded_file_object(klass, attribute, file, content_type = 'text/plain')

    filename = File.basename(file.path)
    klass_label = klass.to_s.underscore

    ActionDispatch::Http::UploadedFile.new(
      tempfile: file,
      filename: filename,
      head: %Q{Content-Disposition: form-data; name="#{klass_label}[#{attribute}]"; filename="#{filename}"},
      content_type: content_type
    )
  end

  # admins

  %w(admin agent).each do |admin|

    test "an #{admin} should be able to see a listing of users" do
      sign_in users(admin.to_sym)
      get :index
      assert_equal 8, assigns(:users).count
    end

    test "an #{admin} should be able to see a filtered of users" do
      sign_in users(admin.to_sym)
      get :index, { role: 'user' }
      assert_equal 4, assigns(:users).count
    end

    test "an #{admin} should be able to update a user" do
      sign_in users(admin.to_sym)
      assert_difference("User.find(2).name.length", -3) do
        patch :update, {id: 2, user: {name: "something", email:"scott.miller2@test.com", zip: '9999', team_list: 'something', priority: 'high'}, locale: :en}
      end
      u = User.find(2)
      assert u.name == "something", "name does not update"
      assert_equal "9999", u.zip, "zip did not update"
      assert_equal ["something"], u.team_list, "groups did not update"
      assert_equal "high", u.priority, "priority did not update"
    end

    test "an #{admin} should be able to see a user profile" do
      xhr :get, :show, { id: 2 }, format: 'js'
      # assert_response :success
      # assert_equal(6, assigns(:topics).count)
    end

    test "an #{admin} should be able to edit a user profile" do
      xhr :get, :edit, { id: 2 }
      # assert_response :success
    end
  end

  test "an admin should be able to update a user and make them an admin" do
    sign_in users(:admin)
    assert_difference("User.admins.count", 1) do
      patch :update, {id: 2, user: {name: "something", email:"scott.miller@test.com", role: 'admin'}, locale: :en}
    end
  end

  test "an admin should be able to bulk invite agents and invitation emails should send" do
    sign_in users(:admin)
    assert_difference "ActionMailer::Base.deliveries.size", 3 do
      assert_difference("User.count", 3) do
        put :invite_users,
          'invite.emails' => 'test1@mail.com, test2@mail.com, test3@mail.com',
          'invite.message' => "this is the test invitation message"
      end
    end
  end

  %w(user editor agent).each do |unauthorized|
    test "an #{unauthorized} should NOT be able to update a user and change their role" do
      sign_in users(unauthorized.to_sym)
      assert_difference("User.admins.count", 0) do
        patch :update, {id: 2, user: {name: "something", email:"scott.miller@test.com", role: "agent"}, locale: :en}
      end
    end
  end

  %w(user editor).each do |unauthorized|
    test "an #{unauthorized} should NOT be able to see the list of users" do
      sign_in users(unauthorized.to_sym)
      get :index
      assert_nil assigns(:users)
    end
  end


end
