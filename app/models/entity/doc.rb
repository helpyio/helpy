module Entity
  class Doc < Base
    expose :id
    expose :title
    expose :body
    expose :keywords
    expose :title_tag
    expose :meta_description
    expose :category_id
    expose :user_id
    expose :active
    expose :rank
    expose :version
    expose :front_page
    expose :created_at
    expose :updated_at
    expose :topics_count
    expose :allow_comments
   end
 end
