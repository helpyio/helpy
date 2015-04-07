# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string
#  identity_url           :string
#  name                   :string
#  admin                  :boolean          default(FALSE)
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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  include Gravtastic

  include PgSearch
  multisearchable :against => [:name, :login, :email]

  paginates_per 15

  # Relationships
  has_and_belongs_to_many :roles
  has_many :topics
  has_many :posts
  has_many :votes

  is_gravtastic

  scope :admins, -> { where(admin: true).order('name asc') }

  def active_assigned_count
    Topic.where(assigned_user_id: self.id).active.isprivate.count
  end

end
