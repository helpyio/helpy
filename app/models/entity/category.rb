module Entity
  class Category < Base
    expose :id
    expose :name
    expose :icon
    expose :keywords
    expose :title_tag
    expose :meta_description
    expose :rank
    expose :front_page
    expose :active
    expose :created_at
    expose :updated_at
  end
end
