
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
#  visibility       :string           default("all")
#

class Category < ActiveRecord::Base

  include SentenceCase

  has_many :docs
  has_paper_trail
  has_ancestry

  acts_as_taggable_on :teams

  translates :name, :keywords, :title_tag, :meta_description, versioning: :paper_trail
  globalize_accessors #:locales => I18n.available_locales, :attributes => [:name, :keywords, :title_tag, :meta_description]


  PUBLIC_VIEWABLE   = %w[all public]
  INTERNAL_VIEWABLE = %w[all internal]
  SYSTEM_RESOURCES = ["Common Replies", "Email templates"]

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ordered, -> { rank(:rank) }
  scope :featured, -> { where(front_page: true) }
  scope :unfeatured, -> { where(front_page: false) }
  scope :publicly, -> { where(visibility: PUBLIC_VIEWABLE) }
  scope :internally, -> { where(visibility: INTERNAL_VIEWABLE) }
  scope :only_internally, -> { where(visibility: 'internal') }
  scope :without_system_resource, -> { where.not(name: SYSTEM_RESOURCES)  }
  after_commit :rebuild_search, only: [:update, :destroy]

  include RankedModel
  ranks :rank

  validates :name, presence: true, uniqueness: true

  def to_param
    "#{id}-#{name.parameterize}" unless name.nil?
  end

  def read_translated_attribute(name)
    globalize.stash.contains?(Globalize.locale, name) ? globalize.stash.read(Globalize.locale, name) : translation_for(Globalize.locale).send(name)
  end

  def system_resource?
    SYSTEM_RESOURCES.include?(name)
  end

  def publicly_viewable?
    PUBLIC_VIEWABLE.include?(visibility)
  end

  def internally_viewable?
    INTERNAL_VIEWABLE.include?(visibility)
  end

  def rebuild_search
    RebuildSearchJob.perform_later
  end

  def self.reorganize(structure, parent_id=nil, parent_rank=0)
    logger.info structure
    structure.each_with_index do |s,i|
      category = Category.find(s[1]["id"])
      category.rank = parent_rank+i+1
      category.parent_id = parent_id
      category.save!
      Category.reorganize(s[1]["children"], category.id, category.rank+100000) if s[1]["children"].present?
    end
  end

end
