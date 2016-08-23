module Entity
  class Post < Base
    expose :id, documentation: { type: "Integer" }
    expose :topic_id, documentation: { type: "Integer", desc: "The Topic this post belongs to." }
    expose :user_id, documentation: { type: "Integer", desc: "The ID representing the author of the post." }
    expose :body
    expose :kind, documentation: { type: "String", desc: "The typo of Post this is- can be 'first', 'reply' or 'note'." }
    expose :active, documentation: { type: "Boolean", desc: "Whether or not the post is visible onsite." }
    expose :created_at
    expose :updated_at
    expose :points, documentation: { type: "Integer" }
  end
end
