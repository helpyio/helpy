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
  before_action :fetch_counts, :only => ['show']
  respond_to :html, :js

  def index
    @users = User.all.page params[:page]
    @user = User.new
  end

  def show
    @user = User.where(id: params[:id]).first
    @topics = Topic.where(user_id: @user.id).page params[:page]

    # We still have to grab the first topic for the user to use the same user partial
    @topic = Topic.where(user_id: @user.id).first
    @tracker.event(category: "Agent: #{current_user.name}", action: "Viewed User Profile", label: @user.name)
    render 'admin/topics/index'
  end

  def edit
    @user = User.where(id: params[:id]).first
    @tracker.event(category: "Agent: #{current_user.name}", action: "Editing User Profile", label: @user.name)
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    fetch_counts

    # update role if admin only
    @user.update_attribute(:role, params[:user][:role]) if current_user.is_admin?

    @topics = @user.topics.page params[:page]
    @topic = Topic.where(user_id: @user.id).first
    @tracker.event(category: "Agent: #{current_user.name}", action: "Edited User Profile", label: @user.name)
    render 'admin/topics/index'
  end

  private

  def user_params
    params.require(:user).permit(
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
      :active
    )
  end

end
