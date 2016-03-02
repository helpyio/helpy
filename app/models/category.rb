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

  include SentenceCase

  has_many :docs
  has_paper_trail

  translates :name, :keywords, :title_tag, :meta_description, versioning: :paper_trail
  globalize_accessors #:locales => I18n.available_locales, :attributes => [:name, :keywords, :title_tag, :meta_description]

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ordered, -> { order('rank ASC') }
  scope :ranked, -> { order('rank ASC') }
  scope :featured, -> { where(front_page: true) }

  include RankedModel
  ranks :rank

  validates_presence_of :name
  validates_uniqueness_of :name

  def to_param
    "#{id}-#{name.parameterize}" unless name.nil?
  end

  def read_translated_attribute(name)
    globalize.stash.contains?(Globalize.locale, name) ? globalize.stash.read(Globalize.locale, name) : translation_for(Globalize.locale).send(name)
  end


end
