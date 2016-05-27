class UsersController < ApplicationController
  before_action :set_user
  before_action :check_auth

  # NOTE: This is for oauth users without email addresses.  This means twitter
  # and sometimes github and facebook.

  # GET/PATCH /users/:id/finish_signup
  def finish_signup
    @page_title = "Please complete your signup"

    if request.patch? && params[:user] #&& params[:user][:email]
      if @user.update(user_params)
        # @user.skip_reconfirmation!
        sign_in(@user, :bypass => true)
        redirect_to root_path, notice: 'Your profile was successfully updated.'
      else
        @show_errors = true
        render
      end
    end
  end

  private

    def check_auth
      redirect_to new_user_session_path unless session['omniauth_uid'].present?
    end

    def set_user
      @user = User.where('uid = ?', session['omniauth_uid']).first
    end

    def user_params
      accessible = [ :name, :email, :bio, :company, :title ] # extend with your own params
      accessible << [ :password, :password_confirmation ] unless params[:user][:password].blank?
      params.require(:user).permit(accessible)
    end
end
