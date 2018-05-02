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

  # admin only
  test "an admin should be able to destroy a user" do
    sign_in users(:admin)
    assert_difference "User.count", -1 do
      xhr :delete, :destroy, id: 3, locale: :en
    end
    assert_response :success
  end

  test "an admin should be able to anonymize a user" do
    sign_in users(:admin)
    xhr :post, :scrub, id: 3, locale: :en
    assert_response :success
    assert "Anonymous User", User.find(3).name
  end

  # admin/agents

  %w(admin agent).each do |admin|

    test "an #{admin} should be able to see a listing of users" do
      sign_in users(admin.to_sym)
      get :index
      assert_equal 9, assigns(:users).count
    end

    test "an #{admin} should be able to see a filtered of users" do
      sign_in users(admin.to_sym)
      get :index, { role: 'user' }
      assert_equal 5, assigns(:users).count
    end

    test "an #{admin} should be able to update a user" do
      sign_in users(admin.to_sym)
      patch :update, {
        id: 6, user: {
          name: "something",
          email:"scott.miller2@test.com",
          zip: '9999',
          team_list: 'something',
          priority: 'high',
          notify_on_private: false,
          notify_on_public: false,
          notify_on_reply: false,
          password: '11223344',
          password_confirmation: '11223344',
        },
        locale: :en }
      u = User.find(6)

      # assert values changed
      assert u.name == "something", "name does not update"
      assert_equal "9999", u.zip, "zip did not update"
      assert_equal ["something"], u.team_list, "groups did not update"
      assert_equal "high", u.priority, "priority did not update"
      assert_equal false, u.notify_on_private, "notification did not update"
      assert_equal false, u.notify_on_public, "notification did not update"
      assert_equal false, u.notify_on_reply, "notification did not update"
      assert_not_equal '$2a$10$NDaQ2l6.7dqkWTbqZGX6RuokqiUrfrcouiKc3YCGKIvz9KxhPt7uK' == u.encrypted_password, "password did not update"
    end

    test "an #{admin} should be able to update a user and unchanged attributes should not change" do
      sign_in users(admin.to_sym)
      user_before_update = User.find(6)
      # assign to team
      user_before_update.team_list = "one"
      user_before_update.save

      patch :update, {
        id: 6, user: {
          name: "something else"
        },
        locale: :en }

      u = User.find(6)
      assert u.name == "something else", "name does not update"
      assert_equal user_before_update.zip, u.zip, "zip updated"
      assert_equal user_before_update.team_list, u.team_list, "groups updates"
      assert_equal user_before_update.priority, u.priority, "priority updated"
      assert_equal user_before_update.role, u.role, "priority updated"
      assert_equal true, u.notify_on_private, "notification updated"
      assert_equal true, u.notify_on_public, "notification updated"
      assert_equal true, u.notify_on_reply, "notification updated"
      assert_equal user_before_update.encrypted_password, u.encrypted_password, "password updated"
    end

    test "an #{admin} should be able to see a user profile" do
      sign_in users(admin.to_sym)
      xhr :get, :show, { id: 9 }, format: 'js'
      assert_response :success
      # assert_equal(6, assigns(:topics).count)
    end

    test "an #{admin} should be able to edit a user profile" do
      sign_in users(admin.to_sym)

      xhr :get, :edit, { id: 9 }
      assert_response :success
    end

  end

  %w(user editor agent).each do |unauthorized|
    test "an #{unauthorized} should NOT be able to destroy a user" do
      sign_in users(unauthorized.to_sym)
      assert_difference("User.count", 0) do
        xhr :delete, :destroy, id: 3, locale: :en
      end
    end

    test "an #{unauthorized} should NOT be able to anonymize a user" do
      sign_in users(unauthorized.to_sym)
      xhr :post, :scrub, id: 3, locale: :en
      assert_not_equal "Anonymous User", User.find(3).name
    end
  end

  test "an admin should be able to update a user and make them an admin" do
    sign_in users(:admin)
    assert_difference("User.admins.count", 1) do
      patch :update, {id: 9, user: {name: "something", email:"scott.miller@test.com", role: 'admin'}, locale: :en}
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
        patch :update, {id: 9, user: {name: "something", email:"scott.miller@test.com", role: "agent"}, locale: :en}
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
