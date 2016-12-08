module Entity
  class Flag < Base
    expose :id, documentation: { type: "Integer" }
    expose :post_id, documentation: { type: "Integer", desc: "The post the flag belongs to." }
    expose :generated_topic_id, documentation: { type: "Integer", desc: "The private topic which is generated after a post has been flagged." }
    expose :reason, documentation: { type: "String", desc: "The reason why the post was flagged for review." }
    expose :created_at
    expose :updated_at
  end
end