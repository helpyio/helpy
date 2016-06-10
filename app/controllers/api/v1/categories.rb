module API
  module V1
    class Categories < Grape::API
      include API::V1::Defaults
      resource :categories do
        desc "Return all public categories"
        get "", root: :categories do
          Category.active.all
        end
      end
    end
  end
end
