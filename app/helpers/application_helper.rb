module ApplicationHelper

  include ActsAsTaggableOn::TagsHelper

  # include TagsHelper

  # Sets the page title and outputs title if container is passed in.
  # eg. <%= title('Hello World', :h2) %> will return the following:
  # <h2>Hello World</h2> as well as setting the page title.
  # def title(str, container = nil)
  #   # @page_title = str
  #   content_tag(:title, str)
  #   content_tag(container, str) if container
  # end

  def title(page_title)
    content_for(:title) { page_title }
  end

  def meta_tag(tag, text)
    content_for :"meta_#{tag}", text
  end

  def yield_meta_tag(tag, default_text='')
    content_for?(:"meta_#{tag}") ? content_for(:"meta_#{tag}") : default_text
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

  def rtl_tags
    stylesheet_link_tag('//cdn.rawgit.com/morteza/bootstrap-rtl/v3.3.4/dist/css/bootstrap-rtl.min.css', "data-turbolinks-track" => true) +
    stylesheet_link_tag('rtl') +
    javascript_include_tag('rtl', "data-turbolinks-track" => true)
  end

  def rtl?(locale_to_check = params[:locale])
    rtl_locale?(locale_to_check || @browser_locale)
  end

  def locale_select
    # options = I18n.available_locales.collect{ |l| [I18n.translate("i18n_languages.#{l}"),l] }

    tag = "<select name='lang' class='form-control' id='lang'>"
    tag += "<option value='#{I18n.locale}'>#{t('translate', default: 'Translate to a different language')}...</option>"

    AppSettings['i18n.available_locales'].sort.each do |locale|
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

  def tag_listing(tags, tagging_type = "message")
    return unless tagging_type == "doc"
    tags.each do |tag|
      concat content_tag(:span, tag, class: "label label-#{tagging_type}-tagging label-#{tag.first.downcase} #{'pull-right' if tagging_type == 'message'}")
    end
  end

  def doc_tag_listing(tags, tagging_type = "message")
    return unless tagging_type == "doc"
    tags.each do |tag|
      concat content_tag(:span, tag, class: "label label-#{tagging_type}-tagging label-#{tag.first.downcase} #{'pull-right' if tagging_type == 'message'}")
    end
  end

  def login_with(with, redirect_to = "/#{I18n.locale}")
    provider = (with == "google_oauth2") ? "google" : with
    link_to(omniauth_authorize_path(:user, with.to_sym, origin: redirect_to), class: ["btn","btn-block","btn-social","oauth","btn-#{provider}"], style: "color:white;", data: {provider: "#{provider}"}, method: :post) do
      content_tag(:span, '', {class: ["fab", "fa-#{provider}"]}).html_safe + I18n.t("devise.shared.links.sign_in_with_provider", provider: provider.titleize)
    end
  end

  # Overrides any styles that are changed in AppSettings
  def css_overrides
    styles = "<style>\n"
    styles += "   #top-bar, header {\n background-color: #{AppSettings['css.top_bar']};\n  }\n" if AppSettings['css.top_bar'] != '3cceff'
    styles += "   .flat-main-panel, #home-search, #page-title, h1, ul.breadcrumb {\n background-color: #{AppSettings['css.search_background']};\n  }\n" if AppSettings['css.search_background'] != 'feffe9'
    styles += "   #get-help-wrapper {\n background-color: #{AppSettings['css.still_need_help']};\n  }\n" if AppSettings['css.top_bar'] != 'FFDF91'
    styles += "   div.add-form {\n background-color: #{AppSettings['css.form_background']};\n  }\n" if AppSettings['css.form_background'] != 'F0FFF0'
    styles += "   .navbar-default .navbar-brand, .navbar-default .navbar-nav > li > a {\n color: #{AppSettings['css.link_color']};\n  }\n" if AppSettings['css.link_color'] != '004084'
    styles += "</style>"
    styles.html_safe
  end

  def theme_css
    styles = "<style>\n"
    styles += "   #top-bar, header {\n background-color: #{AppSettings['css.accent_color']};\n  }\n" unless AppSettings['css.accent_color'].blank?
    styles += "   .flat-main-panel, #home-search, #page-title, h1, ul.breadcrumb {\n background-color: #{AppSettings['css.main_color']};\n  }\n" unless AppSettings['css.main_color'].blank?
    styles += "\n</style>"
    styles.html_safe #if AppSettings['design.css'] != ""
  end

  def css_injector
    styles = "<style>\n"
    styles += "#{AppSettings['design.css']}"
    styles += "\n</style>"
    styles.html_safe if AppSettings['design.css'] != ""
  end

  def get_path(screenshot)
    screenshot.format == "pdf" ? "#{screenshot.public_id}.png" : screenshot.path
  end

  def summernote_lang_js
    if I18n.locale != :en
      "<script src=\"/assets/summernote/lang/summernote-#{summernote_locale}.js\"></script>".html_safe
    end
  end

  def summernote_locale
    # binding.pry
    case I18n.locale
    when :ar, :de, :es, :et, :fi, :fr, :hu, :id, :it, :nl, :pt, :ru, :tr
      "#{I18n.locale.downcase}-#{I18n.locale.upcase}"
    when :"pt-br"
      "pt-BR"
    when :"zh-cn"
      "zh-CN"
    when :"zh-tw"
      "zh_TW"
    when :ja
      "ja-JP"
    when :ko
      "ko-KR"
    when :sv
      "sv-SE"
    when :fa
      "fa-IR"
    when :ca
      "ca-ES"
    else
      "en_EN"
    end
  end

end
