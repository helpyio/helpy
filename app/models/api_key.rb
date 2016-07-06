# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  name         :string
#  date_expired :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class ApiKey < ActiveRecord::Base
  before_validation :generate_access_token, on: :create

  belongs_to :user
  validates :access_token, uniqueness: true
  scope :active, -> { where(date_expired: nil) }


  def expired?
    self.date_expired.present?
  end

  private

    def generate_access_token
      self.access_token = SecureRandom.hex
    end #while self.class.exists?(access_token: access_token)

end
