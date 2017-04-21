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
#  visibility       :string           default('all')
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Category < ActiveRecord::Base

  include SentenceCase

  has_many :docs
  has_paper_trail

  acts_as_taggable_on :teams

  translates :name, :keywords, :title_tag, :meta_description, versioning: :paper_trail
  globalize_accessors #:locales => I18n.available_locales, :attributes => [:name, :keywords, :title_tag, :meta_description]

  PUBLIC_VIEWABLE   = %w[all public]
  INTERNAL_VIEWABLE = %w[all internal]

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ordered, -> { rank(:rank) }
  scope :featured, -> { where(front_page: true) }
  scope :unfeatured, -> { where(front_page: false) }
  scope :publicly, -> { where(visibility: PUBLIC_VIEWABLE) }
  scope :internally, -> { where(visibility: INTERNAL_VIEWABLE) }
  scope :only_internally, -> { where(visibility: 'internal') }

  before_destroy :non_deleteable?

  include RankedModel
  ranks :rank

  validates :name, presence: true, uniqueness: true

  def to_param
    "#{id}-#{name.parameterize}" unless name.nil?
  end

  def read_translated_attribute(name)
    globalize.stash.contains?(Globalize.locale, name) ? globalize.stash.read(Globalize.locale, name) : translation_for(Globalize.locale).send(name)
  end

  def non_deleteable?
    return false if name == "Common Replies"
  end

  def publicly_viewable?
    PUBLIC_VIEWABLE.include?(visibility)
  end

  def internally_viewable?
    INTERNAL_VIEWABLE.include?(visibility)
  end

end
