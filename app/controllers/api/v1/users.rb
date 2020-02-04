module API
  module V1
    class Users < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin agent)
      end

      include API::V1::Defaults
      include Grape::Kaminari

      resource :users, desc: "View and edit users" do

        # throttle max: 200, per: 1.minute

        # LIST ALL USERS
        desc "List all users", {
          entity: Entity::User,
          notes: "List all users"
        }
        get "", root: :users do
          users = User.all
          present users, with: Entity::User
        end

        # LOAD YOUR OWN USER
        desc "Load your own user", {
          entity: Entity::User,
          notes: "Returns the currently logged in user"
        }
        get "self", root: :users do
          present current_user, with: Entity::User
        end

        # SEARCH USERS
        desc "Search users by name, email, account number, phone, etc.", {
          entity: Entity::User,
          notes: "Returns a list of matching users"
        }
        params do
          requires :q, type: String, desc: "User search query"
        end
        get "search", root: :users do
          users = User.user_search(params[:q])
          present users, with: Entity::User
        end

        # SHOW USER
        desc "Show details of a user", {
          entity: Entity::User,
          notes: "Show details of a user"
        }
        params do
          requires :id, type: Integer, desc: "User ID"
        end
        get ":id", root: :users do
          user = User.where(id: permitted_params[:id])
          present user, with: Entity::User
        end

        # CREATE A USER
        desc "Create a new user", {
          entity: Entity::User,
          notes: "Create a new user"
        }
        params do
          requires :name, type: String, desc: "Users full name"
          requires :email, type: String, desc: "Users email address"
          requires :password, type: String, desc: "Users password"
          optional :login, type: String, desc: "Users login (optional)"
          # optional :admin, type: Boolean, desc: "Admin Status"
          optional :bio, type: String, desc: "Users bio"
          optional :signature, type: String, desc: "Users signature"
          optional :role, type: String, desc: "Users role", values: ['user', 'editor', 'agent', 'admin'], default: 'user'
          optional :home_phone, type: String, desc: "Users home phone"
          optional :work_phone, type: String, desc: "Users work phone"
          optional :cell_phone, type: String, desc: "Users cell phone"
          optional :account_number, type: String, desc: "Users account_number"
          optional :company, type: String, desc: "Users company"
          optional :street, type: String, desc: "Users street"
          optional :city, type: String, desc: "Users city"
          optional :state, type: String, desc: "Users state"
          optional :zip, type: String, desc: "Users Postal Code"
          optional :title, type: String, desc: "Users title"
          optional :twitter, type: String, desc: "Users Twitter handle"
          optional :linkedin, type: String, desc: "Users Linkedin username"
          optional :language, type: String, desc: "Users prefered language"
          optional :active, type: Boolean, desc: "User active or deactivated", default: true
          optional :priority, type: String, desc: "Users Priority", values: ['low', 'normal', 'high', 'vip'], default: 'normal'
          optional :notes, type: String, desc: "Notes about the user"
          optional :status, type: String, desc: "User/Agent status"
        end
        post "", root: :users do
          user = User.create!(
            login: permitted_params[:login],
            email: permitted_params[:email],
            account_number: permitted_params[:account_number],
            password: permitted_params[:password],
            name: permitted_params[:name],
            # admin: permitted_params[:admin],
            bio: permitted_params[:bio],
            signature: permitted_params[:signature],
            role: permitted_params[:role],
            home_phone: permitted_params[:home_phone],
            work_phone: permitted_params[:work_phone],
            cell_phone: permitted_params[:cell_phone],
            company: permitted_params[:company],
            street: permitted_params[:street],
            city: permitted_params[:city],
            state: permitted_params[:state],
            zip: permitted_params[:zip],
            title: permitted_params[:title],
            twitter: permitted_params[:twitter],
            linkedin: permitted_params[:linkedin],
            language: permitted_params[:language],
            active: permitted_params[:active],
            priority: permitted_params[:priority],
            notes: permitted_params[:notes],
            status: permitted_params[:status]
            )
          present user, with: Entity::User
        end

        # UPDATE A USER
        desc "Update a user", {
          entity: Entity::User,
          notes: "Update a user"
        }
        params do
          requires :id, type: Integer, desc: "User ID"
          requires :name, type: String, desc: "Users full name"
          requires :email, type: String, desc: "Users email address"
          requires :password, type: String, desc: "Users password"
          optional :account_number, type: String, desc: "Users account_number"
          optional :login, type: String, desc: "Users login (optional)"
          # optional :admin, type: Boolean, desc: "Admin Status"
          optional :bio, type: String, desc: "Users bio"
          optional :signature, type: String, desc: "Users signature"
          optional :role, type: String, desc: "Users role", values: ['user', 'editor', 'agent', 'admin'], default: 'user'
          optional :home_phone, type: String, desc: "Users home phone"
          optional :work_phone, type: String, desc: "Users work phone"
          optional :cell_phone, type: String, desc: "Users cell phone"
          optional :company, type: String, desc: "Users company"
          optional :street, type: String, desc: "Users street"
          optional :city, type: String, desc: "Users city"
          optional :state, type: String, desc: "Users state"
          optional :zip, type: String, desc: "Users Postal Code"
          optional :title, type: String, desc: "Users title"
          optional :twitter, type: String, desc: "Users Twitter handle"
          optional :linkedin, type: String, desc: "Users Linkedin username"
          optional :language, type: String, desc: "Users prefered language"
          optional :active, type: Boolean, desc: "User active or deactivated"
          optional :priority, type: String, desc: "Users Priority- low, normal, high or vip", default: 'normal'
          optional :notes, type: String, desc: "Notes about the user"
          optional :status, type: String, desc: "User/Agent status"
        end
        patch ":id", root: :users do
          user = User.where(id: permitted_params[:id]).first
          user.update!(
            login: permitted_params[:login],
            email: permitted_params[:email],
            account_number: permitted_params[:account_number],
            password: permitted_params[:password],
            name: permitted_params[:name],
            # admin: permitted_params[:admin],
            bio: permitted_params[:bio],
            signature: permitted_params[:signature],
            role: permitted_params[:role],
            home_phone: permitted_params[:home_phone],
            work_phone: permitted_params[:work_phone],
            cell_phone: permitted_params[:cell_phone],
            company: permitted_params[:company],
            street: permitted_params[:street],
            city: permitted_params[:city],
            state: permitted_params[:state],
            zip: permitted_params[:zip],
            title: permitted_params[:title],
            twitter: permitted_params[:twitter],
            linkedin: permitted_params[:linkedin],
            language: permitted_params[:language],
            active: permitted_params[:active],
            priority: permitted_params[:priority],
            notes: permitted_params[:notes],
            status: permitted_params[:status]
            )
          present user, with: Entity::User
        end

        # UPDATE AGENT STATUS
        desc "Update agents status", {
          entity: Entity::User,
          notes: "Update a user"
        }
        params do
          requires :id, type: Integer, desc: "User ID"
          requires :status, type: String, desc: "User/Agent status"
        end
        patch "status/:id", root: :users do
          user = User.where(id: permitted_params[:id]).first
          user.update!(
            status: permitted_params[:status]
            )
          present user, with: Entity::User
        end

        # DELETE A USER
        desc "Delete a user"
        params do
          requires :id, type: Integer, desc: "User ID"
        end
        delete ":id", root: :users do
          user = User.find(permitted_params[:id])
          user.permanently_destroy
          body false
        end

        # ANONYMIZE A USER
        desc "Anonymize a user"
        params do
          requires :id, type: Integer, desc: "User ID"
        end
        post "anonymize/:id", root: :users do
          user = User.find(permitted_params[:id])
          user.scrub
          present user, with: Entity::User
        end

        # INVITE USER
        desc "Invite one or more users to create an account"
        params do
          requires :emails, type: String, desc: "Comma separated list of email addresses"
          requires :message, type: String, desc: "A short message to be included with your invitation"
          requires :role, type: String, desc: "The role given to the new invited users (user, editor, agent, admin)"
        end
        post "invite", root: :users do
          User.bulk_invite(permitted_params["emails"], permitted_params["message"], permitted_params["role"])
          present params[:emails]
        end

      end
    end
  end
end
