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
          requires :device_description, type: String, desc: "The generated description of the device."
        end
        post "", root: :flags do
          newToken = NotificationToken.find_or_create_by({device_token: params[:notification_token]})
          newToken.user_id = current_user.id
          newToken.device_description = params[:device_description]
          newToken.enabled = true
          newToken.save
          present newToken, with: Entity::NotificationToken
        end
      end
    end
  end
end
