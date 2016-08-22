module Entity
  class Doc < Base
    expose :id, documentation: { type: "Integer" }
    expose :slug do |doc|
      doc.to_param
    end
    expose :title
    expose :body
    expose :keywords
    expose :title_tag
    expose :meta_description
    expose :category_id, documentation: { type: "Integer", desc: "The ID of the category the document belongs to." }
    expose :user_id, documentation: { type: "Integer", desc: "The user_id of the author of the document." }
    expose :active, documentation: { type: "Boolean", desc: "Whether or not the document is active on the support site." }
    expose :rank, documentation: { type: "Integer", desc: 'The rank can be used to determine the ordering of categories' }
    expose :version, documentation: { type: "Integer" }
    expose :front_page, documentation: { type: "Boolean", desc: "Whether or not the document should be featured." }
    expose :created_at
    expose :updated_at
    expose :topics_count, documentation: { type: "Integer" }
    expose :allow_comments, documentation: { type: "Boolean", desc: "Whether or not the document should allow commenting." }
    expose :category, using: Entity::Category, if: { category: true }
  end
end
