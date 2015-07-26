# == Schema Information
#
# Table name: votes
#
#  id            :integer          not null, primary key
#  points        :integer          default(1)
#  voteable_type :string
#  voteable_id   :integer
#  user_id       :integer          default(0)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Vote < ActiveRecord::Base

  belongs_to :voteable, :polymorphic => true
  belongs_to :user
  after_create :increment_points_cache

  validates_uniqueness_of :voteable_id, :scope => [:user_id, :voteable_type]

  protected

  def increment_points_cache

    case self.voteable_type

    when "Topic"
      model = Topic.find(self.voteable_id)
    when "Doc"
      model = Doc.find(self.voteable_id)
    when "Post"
      model = Post.find(self.voteable_id)
    end
    model.points += self.points
    model.save

  rescue
    logger.info("Could not increment cache")
  end


end
