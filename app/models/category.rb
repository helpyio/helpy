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

  acts_as_taggable_on :teams

  translates :name, :keywords, :title_tag, :meta_description, versioning: :paper_trail
  globalize_accessors #:locales => I18n.available_locales, :attributes => [:name, :keywords, :title_tag, :meta_description]

  scope :alpha, -> { order('name ASC') }
  scope :active, -> { where(active: true) }
  scope :main, -> { where(section: 'main') }
  scope :ordered, -> { order('rank ASC') }
  scope :ranked, -> { order('rank ASC') }
  scope :featured, -> { where(front_page: true) }
  scope :non_featured, -> { where(front_page: true) }
  scope :viewable, -> { where.not(name: 'Common Replies')}
  scope :is_public, -> { where(public: true) }
  scope :is_internal, -> { where(public: false) }


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

  def is_public_viewable?
    public && name != "Common Replies"
  end

  def is_internal_viewable?
    !public && name != "Common Replies"
  end

end
