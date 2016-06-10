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
#  topics_count     :integer          default(0)
#  allow_comments   :boolean          default(TRUE)



class DocSerializer < ActiveModel::Serializer

  attributes :id, :title, :body, :keywords,
       :title_tag, :meta_description, :category_id, :user_id, :active,
       :rank, :version, :front_page, :created_at, :updated_at, :topics_count, :allow_comments
end
