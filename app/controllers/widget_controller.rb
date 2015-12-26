class WidgetController < ApplicationController

  layout 'widget'
  before_filter :allow_iframe_requests

  def index

    @locale = http_accept_language.compatible_language_from(I18n.available_locales)

    @forums = Forum.ispublic.all

    @topic = Topic.new
    @user = @topic.build_user unless user_signed_in?


  end

  protected

  def allow_iframe_requests
    response.headers.delete('X-Frame-Options')
  end

end
