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

  TEMP_EMAIL_PREFIX = 'change@me'

  validates :name, presence: true, format: { with: /\A\D+\z/ }
  validates :email, presence: true

  attr_accessor :opt_in

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
  has_many :api_keys
  has_attachment  :avatar, accept: [:jpg, :png, :gif]
  is_gravtastic

  ROLES = %w[admin agent editor user]

  # TODO: Will want to refactor this using .or when upgrading to Rails 5
  scope :admins, -> { where('admin = ? OR role = ?',true,'admin').order('name asc') }
  scope :agents, -> { where('admin = ? OR role = ? OR role = ?',true,'admin','agent').order('name asc') }

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
    user = find_by(email: auth.info.email)
    if user
      user.tap do |u|
        u.provider = auth.provider
        u.uid = auth.uid
        u.save!
      end
    else
      where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
        u.provider = auth.provider
        u.uid = auth.uid
        u.email = auth.info.email.present? ? auth.info.email : u.temp_email(auth)
        u.name = auth.info.name
        u.thumbnail = auth.info.image
        u.password = Devise.friendly_token[0,20]
      end
    end
  end

  def temp_email(auth)
    "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com"
  end

  def to_param
    "#{id}-#{name.parameterize}"
  end

  # NOTE: Could have user AR Enumerables for this, but the field was already in the database as a string
  # and changing it could be painful for upgrading installed users. These are three
  # Utility methods for checking the role of an admin:

  def is_admin?
    self.role == 'admin'
  end

  def is_agent?
    %w( agent admin ).include?(self.role)
  end

  def is_editor?
    %w( editor agent admin ).include?(self.role)
  end

end
