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

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => Devise.omniauth_providers

  validates :name, presence: true

  include Gravtastic

  include PgSearch
  pg_search_scope :user_search,
                  against: [:name, :login, :email, :company]

  paginates_per 15

  # Relationships
  has_and_belongs_to_many :roles
  has_many :topics
  has_many :posts
  has_many :votes
  has_many :docs
  has_attachment  :avatar, accept: [:jpg, :png, :gif]
  is_gravtastic

  ROLES = %w[admin agent editor user]

  scope :admins, -> { where(admin: true).order('name asc') }

  def active_assigned_count
    Topic.where(assigned_user_id: self.id).active.count
  end

  def self.create_password
    Devise.friendly_token
  end

  def thumbnail_url
    self.thumbnail.blank? ? self.gravatar_url(size: 60) : self.thumbnail
  end

  def image_url
    self.medium_image || self.gravatar_url(size: 60)
  end

  def self.find_for_oauth(auth)
    if !where(email: auth.info.email).empty?
      user = find_by(email: auth.info.email)
      user.provider = auth.provider
      user.uid = auth.uid
      user.save!
      user
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.provider = auth.provider
        u.uid = auth.uid
        u.email = auth.provider == 'twitter' ? "#{auth.info.nickname}@twitter.com" : auth.info.email
        u.name = auth.info.name
        u.thumbnail = auth.info.image
        u.password = Devise.friendly_token[0,20]
      end
    end
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

end
