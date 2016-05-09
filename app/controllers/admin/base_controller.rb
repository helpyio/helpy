class Admin::BaseController < ApplicationController

  layout 'admin'
  before_action :authenticate_user!
  before_action :verify_admin

end
