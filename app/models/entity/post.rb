module Entity
  class Post < Base
    expose :id, documentation: { type: "Integer" }
    expose :topic_id, documentation: { type: "Integer", desc: "The Topic this post belongs to." }
    expose :user_id, documentation: { type: "Integer", desc: "The ID representing the author of the post." }
    expose :user, using: Entity::User
    expose :body
    expose :kind, documentation: { type: "String", desc: "The type of Post this is- can be 'first', 'reply' or 'note'." }
    expose :active, documentation: { type: "Boolean", desc: "Whether or not the post is visible onsite." }
    expose :created_at
    expose :updated_at
    expose :points, documentation: { type: "Integer" }
    expose :cc, documentation: { type: "String", desc: "Comma separated list of emails to CC" }
    expose :bcc, documentation: { type: "String", desc: "Comma separated list of emails to BCC" }
    expose :raw_email, documentation: { desc: "The original full raw email body" }
    expose :email_to_address, documentation: { desc: "The address a ticket was sent to" }
  end
end
