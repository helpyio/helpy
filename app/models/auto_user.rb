#
# A class for automatically generated users
#

require 'securerandom'

class AutoUser < User
  # tell devise that email is optional
  def email_required?; false; end

  before_validation :signup_guest, :on => :create

  #
  # this will make the form helpers treat AutoUser just
  # as if it was a User.
  #
  def self.model_name
    ActiveModel::Name.new(User)
  end

  def initialize(*args)
    super

    # We don't want email required for AutoUsers, at least not in the forms.
    # The only way to remove a validation set in a super class is to modify the
    # _validators variable. Here we remove the validator set in user.rb on
    # email. We can leave the ones set by devise, because of email_required?()
    _validators[:email].delete_if do |v|
      v.is_a?(ActiveRecord::Validations::PresenceValidator) && v.options.empty?
    end
  end

  def signup_guest
    # the .invalid TLD is reserved for uses like this
    if !self.email.present?
      self.email = SecureRandom.hex(10) + "@email.invalid"
    end
    enc = Devise.token_generator.generate(User, :reset_password_token)
    self.reset_password_token = enc
    self.reset_password_sent_at = Time.now.utc
    self.login = self.email.split("@")[0]
    self.password = User.create_password
  end

end
