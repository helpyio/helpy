#  id               :integer          not null, primary key
#  name             :string
#  icon             :string
#  keywords         :string
#  title_tag        :string
#  meta_description :string
#  rank             :integer
#  front_page       :boolean          default(FALSE)
#  active           :boolean          default(TRUE)
#  permalink        :string
#  section          :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
class CategorySerializer < ActiveModel::Serializer

  attributes :id, :name, :icon, :keywords,
       :title_tag, :meta_description, :rank, :front_page, :active,
       :created_at, :updated_at
end
