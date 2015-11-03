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

  belongs_to :category
  belongs_to :user
  has_many :votes, :as => :voteable

  validates_presence_of :title, :body, :category_id

  include PgSearch
  multisearchable :against => [:title, :body, :keywords]

  translates :title, :body, :keywords, :title_tag, :meta_description
  globalize_accessors

  has_paper_trail

  paginates_per 25
  has_attachments :screenshots, accept: [:jpg, :jpeg, :png, :gif]

  acts_as_taggable

  scope :alpha, -> { order('title ASC') }
  scope :by_category, -> { order("category_id") }
  scope :in_category, -> (cat) { where("category_id = ?", cat).order('front_page DESC, rank ASC') }
  scope :ordered, -> { order('rank ASC') }
  scope :active, -> { where(active: true) }
  scope :recent, -> { order('last_updated DESC').limit(5) }
  scope :all_public_popular, -> { where(active: true).order('points DESC').limit(6) }
  scope :replies, -> { where(category_id: 1) }


  def to_param
    "#{id}-#{title.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def content
    c = RDiscount.new(self.body)
    return c.to_html
  end

end
