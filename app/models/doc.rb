# == Schema Information
#
# Table name: docs
#
#  id               :integer          not null, primary key
#  title            :string
#  body             :text
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  category_id      :integer
#  user_id          :integer
#  active           :boolean          default(TRUE)
#  rank             :integer
#  permalink        :string
#  version          :integer
#  front_page       :boolean          default(FALSE)
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)
#  attachments      :string           default([]), is an Array
#

class Doc < ActiveRecord::Base

  include SentenceCase

  belongs_to :category
  belongs_to :user
  has_many :votes, as: :voteable
  has_one :topic
  has_many :posts, through: :topic

  validates :title, presence: true
  validates :body, presence: true
  validates :category_id, presence: true

  include PgSearch
  multisearchable against: [:title, :body, :keywords],
    :if => lambda { |record| record.category.present? && record.category.publicly_viewable? && record.active && record.category.active? }

  has_paper_trail

  translates :title, :body, :keywords, :title_tag, :meta_description, fallbacks_for_empty_translations: false, versioning: :paper_trail
  globalize_accessors

  paginates_per 25
  has_attachments :screenshots, accept: [:jpg, :jpeg, :png, :gif, :pdf]

  include RankedModel
  ranks :rank

  acts_as_taggable
  acts_as_taggable_on :tags

  scope :alpha, -> { order('title ASC') }
  scope :by_category, -> { order(:category_id) }
  scope :in_category, -> (cat) { where(category_id: cat).order('front_page DESC, rank ASC') }
  scope :ordered, -> { rank(:rank) }
  scope :active, -> { where(active: true) }
  scope :recent, -> { order('last_updated DESC').limit(5) }
  scope :all_public_popular, -> { where(active: true).order('points DESC').limit(6) }
  scope :replies, -> { where(category_id: 1) }
  scope :publicly, -> { joins(:category).where(categories: { visibility: %w[all public] }) }

  def to_param
    return "#{id}-missing-title" if title.nil?  
    "#{id}-#{title.parameterize}"
  end

  def read_translated_attribute(name)
    if globalize.stash.contains?(Globalize.locale, name)
      globalize.stash.read(Globalize.locale, name)
    else
      translation_for(Globalize.locale).send(name)
    end
  end

  def content
    c = RDiscount.new(self.body)
    c.to_html
  end

end
