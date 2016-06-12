module Entity
  class Post < Base
    expose :id
    expose :topic_id
    expose :user_id
    expose :body
    expose :kind
    expose :active
    expose :created_at
    expose :updated_at
    expose :points
  end
end
