# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  login                  :string
#  identity_url           :string
#  name                   :string
#  admin                  :boolean          default(FALSE)
#  bio                    :text
#  signature              :text
#  role                   :string           default("user")
#  home_phone             :string
#  work_phone             :string
#  cell_phone             :string
#  company                :string
#  street                 :string
#  city                   :string
#  state                  :string
#  zip                    :string
#  title                  :string
#  twitter                :string
#  linkedin               :string
#  thumbnail              :string
#  medium_image           :string
#  large_image            :string
#  language               :string           default("en")
#  assigned_ticket_count  :integer          default(0)
#  topics_count           :integer          default(0)
#  active                 :boolean          default(TRUE)
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  provider               :string
#  uid                    :string
#

class Admin::UsersController < Admin::BaseController

  before_action :verify_agent
  before_action :verify_admin, only: ['invite','invite_users']
  before_action :fetch_counts, :only => ['show']
  before_action :get_all_teams
  respond_to :html, :js

  def index
    @roles = [['Team', 'team'], [t(:admin_role), 'admin'], [t(:agent_role), 'agent'], [t(:editor_role), 'editor'], [t(:user_role), 'user']]
    if params[:role].present?
      if params[:role] == 'team'
        @users = User.team.all.page params[:page]
      else
        @users = User.by_role(params[:role]).all.page params[:page]
      end
    else
      @users = User.all.page params[:page]
    end
    @user = User.new
  end

  def show
    get_all_teams
    @user = User.where(id: params[:id]).first
    @topics = Topic.where(user_id: @user.id).page params[:page]

    # We still have to grab the first topic for the user to use the same user partial
    @topic = Topic.where(user_id: @user.id).first
    tracker("Agent: #{current_user.name}", "Viewed User Profile", @user.name)
  end

  def edit
    @user = User.where(id: params[:id]).first
    tracker("Agent: #{current_user.name}", "Editing User Profile", @user.name)
  end

  def update
    @user = User.find(params[:id])

    fetch_counts

    # update team list
    @user.team_list = params[:user][:team_list]

    if @user.update(user_params)

      # update role if admin only
      @user.update_attribute(:role, params[:user][:role]) if current_user.is_admin? && params[:user][:role].present?
      # update password if current user
      @user.update_attribute(:password, params[:user][:password]) if (current_user.id == @user.id) && (params[:user][:password] == params[:user][:password_confirmation])

      @topics = @user.topics.page params[:page]
      @topic = Topic.where(user_id: @user.id).first
      tracker("Agent: #{current_user.name}", "Edited User Profile", @user.name)

      # TODO: Refactor this to use an index method/view on the users model
      respond_to do |format|
        format.html {
          redirect_to admin_root_path
        }
        format.js {
          render 'admin/users/show'
        }
      end
    else
      render :profile
    end
  end

  def invite
  end

  def invite_users
    User.bulk_invite(params["invite.emails"], params["invite.message"], params["role"]) if params["invite.emails"].present?

    respond_to do |format|
      format.html {
        redirect_to admin_users_path
      }
      format.js {
      }
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :profile_image,
      :name,
      :bio,
      :signature,
      :work_phone,
      :cell_phone,
      :email,
      :company,
      :street,
      :city,
      :state,
      :zip,
      :title,
      :twitter,
      :linkedin,
      :language,
      :team_list,
      :priority,
      :active,
      :time_zone,
      :notify_on_private,
      :notify_on_public,
      :notify_on_reply,
    )
  end

end
