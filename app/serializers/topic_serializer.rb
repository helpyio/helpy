# == Schema Information
#
# Table name: topics
#
#  id               :integer          not null, primary key
#  forum_id         :integer
#  user_id          :integer
#  user_name        :string
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
#  doc_id           :integer          default(0)
#  locale           :string
#
class TopicSerializer < ActiveModel::Serializer

  attributes :id, :forum_id, :user_id, :user_name,
       :name, :posts_count, :waiting_on, :last_post_date, :closed_date,
       :last_post_id, :current_status, :private, :assigned_user_id, :points,
       :created_at, :updated_at, :doc_id, :locale
end
