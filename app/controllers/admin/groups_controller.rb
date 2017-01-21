# == Schema Information
#
# Table name: tags
#
#  id                     :integer          not null, primary key
#  name                   :string
#  show_on_helpcenter     :boolean
#  show_on_admin          :boolean
#   show_on_dashboard     :boolean
#

class Admin::GroupsController < Admin::BaseController

  before_action :set_user

  # Restrict API token generation to admin only for now
  before_action :verify_admin
  before_action :get_all_teams

  def index
    @teams = ActsAsTaggableOn::Tag.all
  end

  def edit
    @team = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @team = ActsAsTaggableOn::Tag.find(params[:id])
    if @team.update_columns(params[:acts_as_taggable_on_tag])
      redirect_to admin_groups_path
    else
      render edit_admin_groups_path(@team) 
    end
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
