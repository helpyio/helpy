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
    content_tag(:div, class: ['form-group']) do
      form_tag('#', id: "locale-change", method: 'get') do
        select_tag("lang", options_for_select(I18n.available_locales.collect{ |l| [I18n.translate("i18n_languages.#{l}"),l] }, params[:lang]), {id: "lang", class: "form-control", prompt: "Translate in a different language..."}) + content_tag(:hr)
      end
    end
  end

end
