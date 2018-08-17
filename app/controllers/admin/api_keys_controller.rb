# == Schema Information
#
# Table name: api_keys
#
#  id           :integer          not null, primary key
#  access_token :string
#  user_id      :integer
#  name         :string
#  date_expired :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Admin::ApiKeysController < Admin::BaseController

  before_action :set_user

  # Restrict API token generation to admin
  before_action :verify_admin
  layout 'admin-settings'

  def index
    @api_keys = @user.api_keys.all.order(date_expired: :desc)
    @api_key = ApiKey.new
  end

  def create
    @api_key = ApiKey.new(api_key_params)
    # @api_key.user_id = @user.id
    if @api_key.save
      render
    end
  end

  def destroy
    @api_key = @user.api_keys.where(id: params[:id]).first
    @api_key.update! date_expired: Time.current
  end

  protected

  def set_user
    # An admin should be able to view others API keys
    if current_user.is_admin?
      @user = params[:api_key].present? ? User.find(params[:api_key][:user_id]) : current_user
    else # An agent should be able to view their own API keys only
      @user = current_user
    end
  end

  private

  def api_key_params
    params.require(:api_key).permit(
    :name,
    :user_id
  )
  end


end
