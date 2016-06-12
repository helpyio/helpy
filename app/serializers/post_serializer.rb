# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  body       :text
#  kind       :string
#  active     :boolean          default(TRUE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  points     :integer          default(0)
#
class PostSerializer < ActiveModel::Serializer

  attributes :id, :topic_id, :user_id, :body,
       :kind, :active, :created_at, :updated_at, :points
end
