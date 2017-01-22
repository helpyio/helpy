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
  
  def index
    @teams = ActsAsTaggableOn::Tag.all
  end

  def new
    @team = ActsAsTaggableOn::Tag.new
  end

  def edit
    @team = ActsAsTaggableOn::Tag.find(params[:id])
  end

  def update
    @team = ActsAsTaggableOn::Tag.find(params[:id])
    if @team.update_attributes(group_params)
      redirect_to admin_groups_path
    else
      render edit_admin_groups_path(@team) 
    end
  end

  def create
    if ActsAsTaggableOn::Tag.create(group_params)
      redirect_to admin_groups_path
    else
      render new_admin_group_path
    end
  end

  def destroy
    @team = ActsAsTaggableOn::Tag.find(params[:id])
    @team.destroy
    redirect_to admin_groups_path
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

  def group_params
    params.require(:acts_as_taggable_on_tag).permit(
      :name,
      :show_on_helpcenter,
      :show_on_admin,
      :show_on_dashboard
    )
  end
end
