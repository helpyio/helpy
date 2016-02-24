module ApplicationHelper

  #include TagsHelper

  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  def title(str, container = nil)
    @page_title = str
    content_tag(container, str) if container
  end

  # Outputs the corresponding flash message if any are set
  def flash_messages
    messages = []
    %w(notice warning error).each do |msg|
      messages << content_tag(:div, html_escape(flash[msg.to_sym]), :id => 'flash-message', :class => "#{msg}") unless flash[msg.to_sym].blank?
    end
    messages
  end

  def format_date(date,format='%m/%d/%y - %H:%M')
    date.strftime(format)
  end

  def last_active_time(last_activity)
    content_tag(:span, timeago_tag(last_activity, :limit => 7.days.ago), class: ['hidden-xs']) +
    content_tag(:span, timeago_tag(last_activity, :limit => 0.days.ago), class: ['hidden-sm','hidden-md','hidden-lg'])
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def locale_select

    # options = I18n.available_locales.collect{ |l| [I18n.translate("i18n_languages.#{l}"),l] }

    tag = "<select name='lang' class='form-control' id='lang'>"
    tag += "<option value='#{I18n.locale}'>Translate to a different language...</option>"

    I18n.available_locales.sort.each do |locale|
      selected = "selected" if "#{locale}" == params[:lang]
      I18n.with_locale(locale) do
        tag += "<option value='#{locale}' #{selected}>#{I18n.translate("language_name").mb_chars.capitalize}</option>" #unless locale == I18n.locale
      end
    end
    tag += "</select>"
    tag += "<hr/>"

    content_tag(:div, class: ['form-group']) do
      form_tag('#', id: "locale-change", method: 'get') do
        tag.html_safe
      end
    end

  end

  def login_with(with, redirect_to = "/#{I18n.locale}")
    provider = (with == "google_oauth2") ? "google" : with
    link_to(user_omniauth_authorize_path(with.to_sym, origin: redirect_to), class: ["btn","btn-block","btn-social","oauth","btn-#{provider}"], style: "color:white;", data: {provider: "#{provider}"}) do
      content_tag(:span, '', {class: ["fa", "fa-#{provider}"]}).html_safe + I18n.t("devise.shared.links.sign_in_with_provider", provider: provider.titleize)
    end
  end

end
