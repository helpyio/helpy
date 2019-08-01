module Entity
  class User < Base
    expose :id, documentation: { type: "Integer" }
    expose :login
    expose :name
    # expose :admin
    expose :bio
    expose :signature
    expose :role
    expose :home_phone
    expose :work_phone
    expose :cell_phone
    expose :company
    expose :street
    expose :city
    expose :state
    expose :zip
    expose :title
    expose :twitter
    expose :linkedin
    expose :thumbnail
    expose :medium_image
    expose :large_image
    expose :language
    expose :assigned_ticket_count, documentation: { type: "Integer" }
    expose :topics_count, documentation: { type: "Integer" }
    expose :active, documentation: { type: "Boolean", desc: "Whether or not the user is active." }
    expose :created_at
    expose :updated_at
    expose :email
    expose :sign_in_count, documentation: { type: "Integer" }
    expose :team_list
    expose :account_number
    expose :priority
    expose :notes
    expose :status
  end
end
