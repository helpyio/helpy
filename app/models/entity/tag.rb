module Entity
  class Tag < Base
    expose :id
    expose :name, documentation: {type: 'String', desc: 'The name of the tag'}
    expose :description, documentation: {type: 'String', desc: 'A description for the tag'}
    expose :color, documentation: {type: 'String', desc: 'A color hex code used for the tag'}
  end
end
