module Entity
  class Forum < Base
    expose :id
    expose :name
    expose :topics_count
    expose :last_post_id
    expose :last_post_date
    expose :private
    expose :created_at
    expose :updated_at
    expose :allow_topic_voting
    expose :allow_post_voting
    expose :layout
  end
end
