module API
  module V1
    class NotificationTokens < Grape::API

      before do
        authenticate!
      end

            
      include API::V1::Defaults
      include Grape::Kaminari

      resource :notification_tokens, desc: 'Manage Notification Tokens' do
        desc "Set a Notification Token"
        params do
          requires :notification_token, type: String, desc: "The Token to be saved"
          requires :user_id, type: Integer, desc: "The ID of the User this matches"
        end
        post "", root: :flags do
          nt = NotificationToken.find_first_or_create({token: params[:notification_token]})
          nt.user_id = params[:user_id]
          nt.save

          present nt, with: Entity::NotificationToken
        end
      end
    end
  end
end
