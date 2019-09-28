module Entity
  class Topic < Base
    expose :id, documentation: { type: "Integer" }
    expose :forum_id, documentation: { type: "Integer", desc: "The Forum this topic belongs to." }
    expose :user_id, documentation: { type: "Integer", desc: "The ID representing the creator of the topic."  }
    expose :user_name
    expose :user, using: Entity::User, if: { user: true }
    expose :name, documentation: { type: "String", desc: "The title or subject of the Topic thread." }
    expose :posts_count, documentation: { type: "Integer" }
    # expose :waiting_on, documentation: { type: "String", desc: "Maintained by system, currently unused" }
    expose :last_post_date
    expose :closed_date
    expose :last_post_id, documentation: { type: "Integer", desc: "Cached ID of the most recent post." }
    expose :current_status, documentation: { type: "String", desc: "The status of the Topic. Can be 'new', 'open', 'pending', 'closed', 'spam', 'trash'" }
    expose :private, documentation: { type: "String", desc: "Whether or not the Topic is private (a ticket). Tickets must also have forum_ID 1" }
    expose :assigned_user_id, documentation: { type: "Integer" }
    expose :points, documentation: { type: "Integer", desc: "The number of times this Topic has been voted for." }
    expose :created_at
    expose :updated_at
    expose :doc_id, documentation: { type: "Integer" }
    expose :locale, documentation: { type: "String", desc: "The locale used when the author created the Topic." }
    expose :team_list
    expose :tag_list
    expose :channel, documentation: { type: "String", desc: "The channel that the topic was created from."}
    expose :kind, documentation: { type: "String", desc: "The kind of topic this is, can be 'ticket','discussion','chat', etc."}
    expose :priority, documentation: { type: "String", desc: "Priority of the topic, can be 'low', 'normal', 'high' or 'very_high'" }
    expose :posts, using: Entity::Post, if: { posts: true }
    expose :spam_score
    expose :spam_report
  end
end
