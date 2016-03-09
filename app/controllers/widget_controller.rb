class WidgetController < ApplicationController

  layout 'widget'
  before_filter :allow_iframe_requests

  def index

    @locale = http_accept_language.compatible_language_from(I18n.available_locales)
    @topic = Topic.new
    @user = @topic.build_user unless user_signed_in?

    render 'topics/new', layout: 'widget'
    
  end

  def thanks

  end

  protected

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

end
