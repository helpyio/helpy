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
#

class Doc < ActiveRecord::Base

  include SentenceCase

  belongs_to :category
  belongs_to :user
  has_many :votes, :as => :voteable

  validates_presence_of :title, :body, :category_id

  include PgSearch
  multisearchable :against => [:title, :body, :keywords]

  has_paper_trail

  translates :title, :body, :keywords, :title_tag, :meta_description, fallbacks_for_empty_translations: false, versioning: :paper_trail
  globalize_accessors

  paginates_per 25
  has_attachments :screenshots, accept: [:jpg, :jpeg, :png, :gif]

  include RankedModel
  ranks :rank

  acts_as_taggable

  scope :alpha, -> { order('title ASC') }
  scope :by_category, -> { order(:category_id) }
  scope :in_category, -> (cat) { where(category_id: cat).order('front_page DESC, rank ASC') }
  scope :ordered, -> { order('rank ASC') }
  scope :active, -> { where(active: true) }
  scope :recent, -> { order('last_updated DESC').limit(5) }
  scope :all_public_popular, -> { where(active: true).order('points DESC').limit(6) }
  scope :replies, -> { where(category_id: 1) }

  def to_param
    "#{id}-#{title.parameterize}"
  end

  def read_translated_attribute(name)
    globalize.stash.contains?(Globalize.locale, name) ? globalize.stash.read(Globalize.locale, name) : translation_for(Globalize.locale).send(name)
  end

  def content
    c = RDiscount.new(self.body)
    return c.to_html
  end

end
