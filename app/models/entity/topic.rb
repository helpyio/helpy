module Entity
  class Topic < Base
    expose :id
    expose :forum_id
    expose :user_id
    expose :user_name
    expose :name
    expose :posts_count
    expose :waiting_on
    expose :last_post_date
    expose :closed_date
    expose :last_post_id
    expose :current_status
    expose :private
    expose :assigned_user_id
    expose :points
    expose :created_at
    expose :updated_at
    expose :doc_id
    expose :locale
    expose :posts, using: Entity::Post, if: { posts: true }
  end
end
