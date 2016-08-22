module Entity
  class Forum < Base
    expose :id
    expose :name, documentation: {type: 'String', desc: 'The name of the forum'}
    expose :description, documentation: {type: 'String', desc: 'A description for the forum'}
    expose :topics_count, documentation: { type: "Integer" }
    expose :last_post_id, documentation: { type: "Integer" }
    expose :last_post_date
    expose :private, documentation: {type: 'Boolean', desc: 'Whether the forum is publically accessible'}
    expose :created_at
    expose :updated_at
    expose :allow_topic_voting, documentation: {type: 'Boolean', desc: 'Whether or not to allow topic voting'}
    expose :allow_post_voting, documentation: {type: 'Boolean', desc: 'Whether or not to allow voting of reply posts'}
    expose :layout, documentation: {type: 'String', desc: 'The layout the forum uses. Can be Table, Grid, or Q&A'}
    expose :topics, using: Entity::Topic, if: { topics: true } do |forum, options|
      forum.topics.reverse.limit(options[:topics_limit])
    end

  end
end
