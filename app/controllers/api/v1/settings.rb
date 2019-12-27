module API
  module V1
    class Settings < Grape::API

      before do
        authenticate!
        restrict_to_role %w(admin)
      end

      include API::V1::Defaults
      resource :settings, desc: "See and edit site settings" do

        # throttle max: 200, per: 1.minute

        # LIST ALL SETTINGS
        desc "List all settings and their values"
        params do
        end
        get "", root: :settings do
          settings = AppSettings.get_all
          present settings
        end

        # UPDATE SETTING
        desc "Update a setting value"
        params do
          requires :key, type: String
          requires :value, type: String
        end
        post "", root: :settings do
          AppSettings[params[:key]] = params[:value]
          present AppSettings[params[:key]]
        end
      end
    end
  end
end
