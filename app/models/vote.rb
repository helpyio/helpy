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

  validates :voteable_id, uniqueness: { scope: [:user_id, :voteable_type] }

  protected

  def increment_points_cache
    votable_class = self.class.const_get(self.voteable_type.to_sym)
    votable_class.update_counters(self.voteable_id, points: self.points)
  end


end
