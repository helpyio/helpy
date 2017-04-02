class Webhook::BaseController < ApplicationController

  def check_token
    unless params[:token] == AppSettings["settings.webhook_key"]
      redirect_to '/errors/not_found'
    end
  end

end
