class Admin::BaseController < ApplicationController

  layout 'admin'
  before_action :authenticate_user!
  before_action :verify_admin

  protected

  def pipeline
    @pipeline = true
  end

  def remote_search
    @remote_search = true
  end

end
