# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  forum_id       :integer
#  user_id        :integer
#  name           :string
#  posts_count    :integer          default(0), not null
#  last_post_date :datetime
#  last_post_id   :integer
#  status         :string           default("Open")
#  private        :boolean          default(FALSE)
#  cheatsheet     :boolean          default(FALSE)
#  points         :integer          default(0)
#  post_cache     :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Topic < ActiveRecord::Base

  belongs_to :forum, :counter_cache => true
  belongs_to :user
  has_many :posts, :dependent => :delete_all
  has_many :votes, :as => :voteable

  include PgSearch
  multisearchable :against => [:name, :post_cache],
                  :if => lambda { |record| record.private = false}

  # various scopes
  scope :recent, -> { order('created_at DESC').limit(8) }
  scope :open, -> { where(status: "Open") }
  scope :resolved, -> { where(status: "Resolved") }
  scope :chronologic, -> { order('updated_at DESC') }
  scope :by_popularity, -> { order('points DESC') }
  scope :active, -> { where("status <> 'Spam'") }
  scope :front, -> { limit(6) }

  # provided both public and private instead of one method, for code readability
  scope :isprivate, -> { where("status <> 'Spam'").where(private: true)}
  scope :ispublic, -> { where("status <> 'Spam'").where(private: false)}

  before_save :check_for_private
  #acts_as_taggable

  validates_presence_of :name
  validates_length_of :name, :maximum => 255

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

  def self.fetch_email

    @config = YAML.load_file("#{RAILS_ROOT}/config/settings.yml")
    @config = @config[RAILS_ENV].to_options

    @fetcher = Fetcher.create({:receiver => MailProcessor}.merge(@config))
    @fetcher.fetch

  end

  def open?
    self.status == "Open"
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
