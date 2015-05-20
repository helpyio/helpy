# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Category < ActiveRecord::Base

  has_many :docs
  has_paper_trail

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ranked, -> { order('rank ASC') }
  scope :featured, -> {where(front_page: true) }

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}" unless name.nil?
  end

  validates_presence_of :name
  validates_uniqueness_of :name

end
