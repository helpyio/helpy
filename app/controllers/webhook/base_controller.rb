class Webhook::BaseController < ApplicationController

  def enabled?(kind)
    unless AppSettings["webhook.#{kind}_enabled"] == '1'
      render json: { status: 404, message: "The requested resource could not be found." }, status: 404
    end
  end

  def check_token(token)
    unless params[:token] == token
      render json: { status: 422, message: "The supplied token could not be found or was invalid." }, status: 422
    end
  end

end
