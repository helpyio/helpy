class UsersController < ApplicationController

  #before_filter :authenticate!

  def update

    @user = User.where(id: params[:id]).first

    #Update the user
    @user.name = params[:user][:name]
    @user.admin = params[:user][:admin]
    @user.save


    respond_to do |format|
      format.html {
        redirect_to admin_users_path
      }
      format.js
    end

  end

  private


end
