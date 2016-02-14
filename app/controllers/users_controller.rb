class UsersController < ApplicationController

  before_filter :authenticate_user!, except: :set_client_id

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
      @user.admin = params[:user][:admin]
      @user.active = params[:user][:active]
    else
      @user = current_user
    end

    #Update the user
    @user.name = params[:user][:name]
    @user.bio = params[:user][:bio]
    @user.signature = params[:user][:signature]
    @user.work_phone = params[:user][:work_phone]
    @user.cell_phone = params[:user][:cell_phone]
    @user.email = params[:user][:email]
    @user.company = params[:user][:company]
    @user.street = params[:user][:street]
    @user.city = params[:user][:city]
    @user.state = params[:user][:state]
    @user.zip = params[:user][:zip]
    @user.title = params[:user][:title]
    @user.twitter = params[:user][:twitter]
    @user.linkedin = params[:user][:linkedin]
    @user.language = params[:user][:language]
    @user.save

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


end
