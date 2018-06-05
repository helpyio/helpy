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
#  invitation_token       :string
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_accepted_at :datetime
#  invitation_limit       :integer
#  invited_by_id          :integer
#  invited_by_type        :string
#  invitations_count      :integer          default(0)
#  invitation_message     :text
#  time_zone              :string           default("UTC")
#  profile_image          :string
#  notify_on_private      :boolean          default(FALSE)
#  notify_on_public       :boolean          default(FALSE)
#  notify_on_reply        :boolean          default(FALSE)
#  account_number         :string
#  priority               :string           default("normal")
#

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => Devise.omniauth_providers

  INVALID_NAME_CHARACTERS = /\A('|")|('|")\z/

  # Add preferences to user model
  include RailsSettings::Extend

  TEMP_EMAIL_PREFIX = 'change@me'

  attr_accessor :opt_in

  validates :name, presence: true, format: { with: /\A\D+\z/ }
  validates :email, presence: true


  include Gravtastic
  mount_uploader :profile_image, ProfileImageUploader

  include PgSearch
  pg_search_scope :user_search,
                  against: [:name, :login, :email, :company, :account_number, :home_phone, :work_phone, :cell_phone]

  paginates_per 15

  # Relationships

  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :docs
  has_many :backups, dependent: :delete_all
  has_many :api_keys, dependent: :destroy

  has_attachment  :avatar, accept: [:jpg, :png, :gif]
  is_gravtastic

  after_invitation_accepted :set_role_on_invitation_accept
  after_create :enable_notifications_for_admin
  before_save :reject_invalid_characters_from_name
  acts_as_taggable_on :teams

  ROLES = %w[admin agent editor user]

  # TODO: Will want to refactor this using .or when upgrading to Rails 5
  scope :admins, -> { where('admin = ? OR role = ?',true,'admin').order('name asc') }
  scope :agents, -> { where('admin = ? OR role = ? OR role = ?',true,'admin','agent').order('name asc') }
  scope :customers, -> { where('admin = ? and role = ?',false,'user').where.not(role: ['agent','admin','editor']).where.not(id: 2).order('name asc') }
  scope :team, -> { where('admin = ? OR role = ? OR role = ? OR role = ?',true,'admin','agent','editor').order('name asc') }
  scope :active, -> { where(active: true)}
  scope :by_role, -> (role) { where(role: role) }

  def set_role_on_invitation_accept
    self.role = self.role.presence || "agent"
    self.active = true
    self.save
  end

  def enable_notifications_for_admin
    if self.role == "admin"
      self.notify_on_private = true
      self.notify_on_public = true
      self.notify_on_reply = true
    end
  end

  # Permanently destroy a user along with all owned records
  # change doc ownership
  def permanently_destroy
    return if self.is_admin?
    return if self.id == 2 #prevent the system user from being destroyed

    DeleteUserJob.perform_later(self.id)
  end

  # Removes or anonymizes associated records
  def scrub
    return if self.is_admin?
    return if self.id == 2 #prevent the system user from anonymized

    # unassign from any topics assigned to
    self.unassign_all

    # "forget user"
    self.anonymize
  end

  # anonymizes a users attributes
  def anonymize
    return if self.is_admin?

    # anonymize own attributes
    self.update!(
      login: 'anon',
      name: 'Anonymous User',
      role: 'user',
      signature: nil,
      home_phone: nil,
      work_phone: nil,
      cell_phone: nil,
      company: nil,
      street: nil,
      city: nil,
      state: nil,
      zip: nil,
      title: nil,
      twitter: nil,
      linkedin: nil,
      bio: nil,
      thumbnail: nil,
      medium_image: nil,
      large_image: nil,
      profile_image: nil,
      current_sign_in_ip: nil,
      last_sign_in_ip: nil,
      encrypted_password: SecureRandom.hex(24),
      account_number: nil,
      active: false,
      email: 'change@me-' + SecureRandom.hex(5) + '.anonymous'
    )

    # anonymize cached attributes (topics)
    self.topics.update_all(user_name: 'Anonymized User')

    # rebuild index
  end

  # Unassign from all tickets
  def unassign_all
    Topic.where(assigned_user_id: self.id).update_all(assigned_user_id: nil)
  end

  # Can this user be deleted? Protects admins/system user from accidental delete
  def can_scrub_and_delete?
    return false if self.id == 2 || self.is_admin?
    true
  end

  def self.notifiable_on_public
    agents.where(notify_on_public: true).reorder('id asc')
  end

  def self.notifiable_on_private
    agents.where(notify_on_private: true).reorder('id asc')
  end

  def self.notifiable_on_reply
    agents.where(notify_on_reply: true).reorder('id asc')
  end

  def active_assigned_count
    Topic.where(assigned_user_id: self.id).active.count
  end

  def is_restricted?
    self.team_list.count > 0 && !self.is_admin?
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
      # NOTE: this stopped working with the test, not sure why. Replaced with
      # find_or_create_by and everything passed again:

      # where(provider: auth.provider, uid: auth.uid).first_or_create do |u|
      # it turns out that is not part of the public rails api, despite being
      # used in the wild. https://github.com/rails/rails/issues/23495

      find_or_create_by(provider: auth.provider, uid: auth.uid) do |u|
        u.email = auth.info.email.present? ? auth.info.email : u.temp_email(auth)
        u.name = auth.info.name.present? ? auth.info.name : "Name Missing"
        u.role = 'user'
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

  def signup_guest
    enc = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc

    self.login = self.email.split("@")[0]
    self.password = User.create_password
    self.save
  end

  # evaluates to true if they are a priority (high/vip) user
  def priority?
    self.priority == 'high' || self.priority == 'vip'
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

  def self.bulk_invite(emails, message, role)
    #below line merge comma saperated emails as well as emails saperated by new lines
    emails = emails.each_line.reject { |l| l =~ /^\s+$/ }.map { |l| l.strip.split(', ') }.flatten

    emails.each do |email|
      is_valid_email = email.match('^.+@.+$')
      if is_valid_email
        User.invite!({email: email}) do |user|
          user.invitation_message = message
          user.name = "Invited User: #{email}"
          user.role = role
          user.active = false
        end
      end
    end
  end

  #when using deliver_later attr_accessor :message becomes nil on mailer view
  def send_devise_notification(notification, *args)
    devise_mailer.send(notification, self, *args).deliver_later
  end

  # check if user is active or not
  def active_for_authentication?
    super && self.active?
  end

  # message to the user that is not allowed to login
  def inactive_message
    "You are not allowed to log in!"
  end

  def self.register email, user_name
    # this method is very similar to email_processor#create_user
    # actually it was copyied from there.
    # it should create an issue to properly refactor and
    # preserve the DRY principle.

    # create user
    usr = User.new

    token, enc = Devise.token_generator.generate(User, :reset_password_token)
    usr.reset_password_token = enc
    usr.reset_password_sent_at = Time.now.utc

    usr.email = email
    usr.name = user_name
    usr.password = User.create_password
    if usr.save
      UserMailer.new_user(usr.id, token).deliver_later
    end

    usr
  end

  private

  def reject_invalid_characters_from_name
    self.name = name.gsub(INVALID_NAME_CHARACTERS, '') if !!name.match(INVALID_NAME_CHARACTERS)
  end

end
