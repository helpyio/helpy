class LocalesController < ApplicationController

  theme :theme_chosen

  respond_to :html


  def select
    @page_title = t(:select_locale, default: "Change your Locale")
    add_breadcrumb @page_title
  end

  def switch_locale
    binding.pry
    I18n.locale = params[:to]
    redirect_to root_path
  end

  def redirect_on_locale
    #redirect_to root_path, status: 301
    redirect_to "/#{I18n.locale.to_s}", status: 301
  end

end
