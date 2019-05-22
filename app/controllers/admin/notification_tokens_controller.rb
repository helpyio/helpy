# == Schema Information
#
# Table name: notification_tokens
#
#  id           :integer          not null, primary key
#  device_token :string
#  user_id      :integer
#  enabled      :boolean
#  device_desc  :string


class Admin::NotificationTokensController < Admin::BaseController

  before_action :set_user

  # Restrict API token generation to admin
  before_action :verify_admin
  layout 'admin-settings'

  def index
    @notification_tokens = @user.notification_tokens.all.order(updated_at: :desc)
  end

  def create
    @notification_token = NotificationToken.new(notification_token_params)
    # @api_key.user_id = @user.id
    if @api_key.save
      render
    end
  end

  def destroy
    @notification_token = @user.notification_tokens.where(id: params[:id]).first
    @notification_token.update! date_expired: Time.current
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

  def notification_token_params
    params.require(:notification_token).permit(
    :device_token,
    :user_id,
    :enabled,
    :device_desc
  )
  end
end
