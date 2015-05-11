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

  belongs_to :category
  has_many :votes, :as => :voteable

  validates_presence_of :title, :body, :category_id

  include PgSearch
  multisearchable :against => [:title, :body, :keywords]

  has_paper_trail

  paginates_per 25

  acts_as_taggable
  before_create :build_permalink

  scope :alpha, -> { order('title ASC') }
  scope :by_category, -> { order("category_id") }
  scope :in_category, -> (cat) { where("category_id = ?", cat).order('front_page DESC, rank ASC') }
  scope :ordered, -> { order('rank ASC') }
  scope :active, -> { where(active: true) }
  scope :recent, -> { order('last_updated DESC').limit(5) }
  scope :all_public_popular, -> { where(active: true).order('points DESC').limit(6) }
  scope :replies, -> { where(category_id: 1) }

  #simple_column_search :body, :title, :keywords

  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def content
    c = RDiscount.new(self.body)
    return c.to_html
  end

  protected

  def build_permalink
    self.permalink = PermalinkFu.escape(self.title)
  end

end
