# == Schema Information
#
# Table name: categories
#
#  id               :integer          not null, primary key
#  name             :string
#  keywords         :string
#  title_tag        :string(70)
#  meta_description :string(160)
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

  #before_create :make_link
  #before_create :build_permalink

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ranked, -> { order('rank ASC') }

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end


  protected

  def build_permalink
    self.permalink = PermalinkFu.escape(self.title)
  end

end
