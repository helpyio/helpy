# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  rank       :integer
#  active     :boolean          default(TRUE)
#  link       :string
#  section    :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ActiveRecord::Base

  has_many :docs

  before_create :make_link

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ranked, -> { order('rank ASC') }

  def to_params
    self.link
  end


  protected

  def make_link
    self.link = PermalinkFu.escape(self.name)
  end

end
