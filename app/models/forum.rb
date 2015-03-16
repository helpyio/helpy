class Forum < ActiveRecord::Base

  has_many :topics, :dependent => :delete_all
  has_many :posts, :through => :topics

  scope :alpha, -> { order('name ASC') }

  validates_presence_of :name
  validates_length_of :name, :maximum => 255
  validates_length_of :description, :maximum => 1000
    
  def total_posts
    self.posts.count
  end

  def to_param
    "#{id}-#{name.gsub(/[^a-z0-9]+/i, '-')}"
  end

end
