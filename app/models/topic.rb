# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  name             :string
#  posts_count      :integer          default(0), not null
#  waiting_on       :string           default("admin"), not null
#  last_post_date   :datetime
#  closed_date      :datetime
#  last_post_id     :integer
#  current_status   :string           default("new"), not null
#  private          :boolean          default(FALSE)
#  assigned_user_id :integer
#  cheatsheet       :boolean          default(FALSE)
#  points           :integer          default(0)
#  post_cache       :text
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class Topic < ActiveRecord::Base

  belongs_to :forum, :counter_cache => true
  belongs_to :user
  has_many :posts, :dependent => :delete_all
  has_many :votes, :as => :voteable

  paginates_per 25

  include PgSearch
  multisearchable :against => [:name, :post_cache],
                  :if => lambda { |record| record.private = false}

  # various scopes
  scope :recent, -> { order('created_at DESC').limit(8) }
  scope :open, -> { where(current_status: "open") }
  scope :unread, -> { where(current_status: "new") }
  scope :pending, -> { where(current_status: "pending") }
  scope :mine, -> (user) { where("assigned_user_id = ?", user) }
  scope :closed, -> { where(current_status: "closed") }
  scope :spam, -> { where(current_status: "spam")}

  scope :chronologic, -> { order('updated_at DESC') }
  scope :by_popularity, -> { order('points DESC') }
  scope :active, -> { where("current_status <> 'spam'") }
  scope :front, -> { limit(6) }

  # provided both public and private instead of one method, for code readability
  scope :isprivate, -> { where("current_status <> 'Spam'").where(private: true)}
  scope :ispublic, -> { where("current_status <> 'Spam'").where(private: false)}

  before_save :check_for_private
  #acts_as_taggable

  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  def assigned_user
    User.where(id: self.assigned_user_id).first
  end

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def email_subject
    "##{self.id} | #{self.name}"
  end

  def open?
    self.current_status == "open"
  end

  def open
    self.update(current_status: "open")
  end

  def close
    self.current_status = "closed"
    self.closed_date = Time.now
  end

  #updates the last post date, called when a post is made
  def self.last_post
    Topic.post(:first, :order => 'updated_at DESC')
  end

  #Callback method to check and see if this topic is in a private forum
  def check_for_private
    self.private = true if self.forum.private?
  end

end
