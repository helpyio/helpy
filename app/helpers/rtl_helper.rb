module RtlHelper
  def rtl_tags
    stylesheet_link_tag('bootstrap-rtl.min', "data-turbolinks-track" => true) +
    stylesheet_link_tag('rtl') +
    javascript_include_tag('rtl', "data-turbolinks-track" => true)
  end

  def rtl?(locale_to_check = nil)
    locale_to_check = I18n.locale if locale_to_check.nil?

    rtl_locale?(locale_to_check)
  end

  def rtl_locale?(locale)
    locale = locale.to_s
    return true if %w(ar dv he iw fa nqo ps sd ug ur yi).include?(locale)

    false
  end
end
