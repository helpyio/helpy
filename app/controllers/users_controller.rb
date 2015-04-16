class UsersController < ApplicationController

  #before_filter :authenticate!
  add_breadcrumb I18n.t :home, :root_path

  def show
    @user = current_user
  end


  def edit
    @page_title = t(:my_profile)
    @title_tag = "#{Settings.site_name} Support: My Profile"
    add_breadcrumb @page_title, categories_path

    @user = User.where(id: current_user.id).first
  end


  def update

    if current_user.admin?
      @user = User.where(id: params[:id]).first
    else
      @user = current_user
    end

    #Update the user
    @user.name = params[:user][:name]
    @user.admin = params[:user][:admin]
    @user.save


    respond_to do |format|
      format.html {
        if current_user.admin?
          redirect_to admin_users_path
        else
          redirect_to root_path
        end
      }
      format.js
    end

  end

  private


end
