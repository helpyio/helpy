require 'doorkeeper/grape/helpers'

module API
  module V1
    class Users < Grape::API
      helpers Doorkeeper::Grape::Helpers
      #
      # before do
      #   doorkeeper_authorize!
      # end

      before do
        authenticate!
      end

      include API::V1::Defaults

      # LIST ALL USERS
      resource :users do
        desc "List all users", {
          entity: Entity::User,
          notes: "List all users"
        }
        get "", root: :users do
          users = User.all
          present users, with: Entity::User
        end
      end

      # SHOW USER
      resource :users do
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
      end

      # CREATE A USER
      resource :users do
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
        end
        post "", root: :users do
          user = User.create!(
            login: permitted_params[:login],
            email: permitted_params[:email],
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
            active: permitted_params[:active]
            )
          present user, with: Entity::User
        end
      end

      # UPDATE A USER
      resource :users do
        desc "Update a user", {
          entity: Entity::User,
          notes: "Update a user"
        }
        params do
          requires :id, type: Integer, desc: "User ID"
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
        end
        patch ":id", root: :users do
          user = User.where(id: permitted_params[:id]).first
          user.update!(
            login: permitted_params[:login],
            email: permitted_params[:email],
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
            active: permitted_params[:active]
            )
          present user, with: Entity::User
        end
      end

    end
  end
end
