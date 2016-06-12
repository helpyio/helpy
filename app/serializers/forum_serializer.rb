# == Schema Information
#
# Table name: forums
#
#  id                 :integer          not null, primary key
#  name               :string
#  description        :text
#  topics_count       :integer          default(0), not null
#  last_post_date     :datetime
#  last_post_id       :integer
#  private            :boolean          default(FALSE)
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  allow_topic_voting :boolean          default(FALSE)
#  allow_post_voting  :boolean          default(FALSE)
#  layout             :string           default("table")
#

class ForumSerializer < ActiveModel::Serializer

  attributes :id, :name, :topics_count, :last_post_date,
       :last_post_id, :private, :created_at, :updated_at, :allow_topic_voting,
       :allow_post_voting, :layout
end
