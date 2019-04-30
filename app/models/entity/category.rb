module Entity
  class Category < Base
    expose :id, documentation: {type: 'Integer', desc: 'Category ID'}
    expose :slug do |category|
      category.to_param
    end#, documentation: {type: 'String', desc: 'Parameterised Category ID'}
    expose :name, documentation: {type: 'String', desc: 'The name of the category of articles'}
    expose :icon, documentation: {type: 'String', desc: 'An icon that represents the category'}
    expose :keywords, documentation: {type: 'String', desc: 'Keywords that will be used for internal search and SEO'}
    expose :title_tag, documentation: {type: 'String', desc: 'An alternate title tag that will be used if provided'}
    expose :meta_description, documentation: {type: 'String', desc: 'A short description for SEO and internal purposes'}
    expose :rank, documentation: {type: 'Integer', desc: 'The rank can be used to determine the ordering of categories'}
    expose :front_page, documentation: {type: 'Boolean', desc: 'Whether or not the category should appear on the front page'}
    expose :active, documentation: {type: 'Boolean', desc: 'Whether or not the category is live on the site'}
    expose :visibility, documentation: {type: 'String', desc: 'The visibility of the category.  Can be all, internal or public.'}
    expose :created_at
    expose :updated_at
    expose :docs, using: Entity::Doc, if: { docs: true } do |category, options|
      category.docs.includes(:translations).ordered.limit(options[:docs_limit])
    end
  end
end
