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

class UserTest < ActiveSupport::TestCase

  should have_many(:topics)
  should have_many(:posts)
  should have_many(:docs)
  should validate_presence_of(:name)
  should validate_presence_of(:email)
  should validate_uniqueness_of(:email)

  test "should count number of assigned topics" do
    @user = User.find(1)

    assert @user.active_assigned_count == 2
    assert_difference '@user.active_assigned_count', 1 do
      Topic.find(5).assign(1)
    end
  end

  test 'should only track validation errors once' do
    user = User.new(email: User.first.email)
    user.validate
    errs = user.errors.full_messages
    # Verify there are no duplicate errors!
    assert_equal errs.length, errs.uniq.length
  end

  test "should accept w3c example names" do

    names = [
      "Björk Guðmundsdóttir",
      "Isa bin Osman",
      "毛泽东",
      "María-Jose Carreño Quiñones",
      "Борис Николаевич Ельцин",
      "Наина Иосифовна Ельцина",
      "John Q. Public",
      "V. S. Achuthanandan",
      "Nguyễn Tấn Dũng",
      "Steve Johns-Smith",
      "Scott",
      "JJ Adams",
      "T O'Shea"
    ]

    names.each do |name|
      user = User.create!(
        name: name,
        email: "#{name.split(" ")[0]}@testing.com",
        password: '12345678'
      )

      assert_equal name, user.name

    end

  end

  test "should not accept names with numbers" do
    names = [
      "Vasiya2",
      "123123"
    ]

    names.each do |name|
      user = User.create(name: name, email: "#{name.split(" ")[0]}@testing.com", password: "12345678")
      assert_equal user.valid?, false
    end
  end

  test "is_agent? should evaluate to true if user is an agent" do
    assert_equal User.find(6).is_agent?, true

    # Admin should also evaluate to true because they cover all capabilities
    # of an agent
    assert_equal User.find(1).is_agent?, true
  end

  test "is_agent? should evaluate to false if user is an editor" do
    assert_equal User.find(7).is_agent?, false
  end

  test "is_admin? should evaluate to true if user is an admin" do
    assert_equal User.find(1).is_admin?, true
  end

  test "is_admin? should evaluate to false if user is an agent" do
    assert_equal User.find(6).is_admin?, false
  end

  test "is_admin? should evaluate to false if user is an editor" do
    assert_equal User.find(7).is_admin?, false
  end

  test "is_editor? should evaluate to true if user is an agent" do
    assert_equal User.find(7).is_editor?, true

    # Admin should also evaluate to true because they cover all capabilities
    # of an editor
    assert_equal User.find(1).is_editor?, true

    # Agent should also evaluate to true because they cover all capabilities
    # of an editor
    assert_equal User.find(6).is_editor?, true
  end

end
