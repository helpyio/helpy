module Entity
  class Search < Base
    expose :id
    expose :content
    expose :searchable_id
    expose :searchable_type
    expose :created_at
    expose :updated_at
  end
end
