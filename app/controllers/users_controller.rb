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

class UsersController < ApplicationController

  before_action :authenticate_user!, except: :set_client_id

  def show
    @user = current_user
  end

  def edit
    @page_title = t(:my_profile)
    @title_tag = "#{Settings.site_name} Support: My Profile"
    add_breadcrumb @page_title, categories_path

    @user = current_user
  end

  def update

    if current_user.admin?
      @user = User.find(params[:id])
      @user.admin = params[:user][:admin]
      @user.active = params[:user][:active]
    else
      @user = current_user
    end

    @user.update(user_params)

    if current_user.admin?
      fetch_counts
      @topics = @user.topics.page params[:page]
      @tracker.event(category: "Agent: #{current_user.name}", action: "Edited User Profile", label: @user.name)
    end

    respond_to do |format|
      format.html {
        redirect_to root_path
      }
      format.js {
        render 'admin/tickets' if current_user.admin?
      }
    end

  end

  def set_client_id
    
    session[:client_id] = params[:client_id]
    render nothing: true

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
      :language
    )
  end

end
