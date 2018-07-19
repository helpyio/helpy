# Helpers for styling the admin layout and views

module Admin::LayoutHelper

  def settings_header(name)
    content_tag :div, class: 'admin-header' do
      content_tag :h3 do
        concat show_responsive_nav
        concat "#{t(:settings, default: "Settings")}: #{t(name.to_sym, default: name.capitalize)}"
      end
    end
  end

  def show_responsive_nav
    content_tag :small do
      content_tag :span, nil, class: 'fas fa-caret-square-left btn show-ticket-menu hidden-lg hidden-md'
    end
  end

  def hide_responsive_nav
    content_tag :div, class: "pull-right hidden-lg hidden-md" do
      content_tag :span, nil, class: "fas fa-times btn show-ticket-menu close-ticket-menu"
    end
  end

end
