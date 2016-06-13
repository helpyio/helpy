class Theme < Rails::Generators::Base
  source_root File.expand_path("../templates", __FILE__)
  argument    :theme_name, type: :string
  desc        "Creates a new theme"

  def create_theme_directory
    empty_directory theme_views_layout
    empty_directory theme_images_directory
    empty_directory theme_javascripts_directory
    empty_directory theme_stylesheets_directory
    empty_directory theme_locales_directory
    create_file     "#{theme_images_directory}/.gitkeep", nil
    create_file     "#{theme_locales_directory}/.gitkeep", nil
  end

  def copy_manifest_files
    copy_file       "all.js", "#{theme_javascripts_directory}/all.js"
    copy_file       "all.css", "#{theme_stylesheets_directory}/all.css"
    copy_file       "about.markdown", "#{theme_directory}/about.markdown"
  end

  def copy_layout_file
    template_engine = Rails.configuration.app_generators.rails[:template_engine]
    if template_engine == :liquid
      template "layout.html.liquid", "#{theme_views_layout}/#{theme_name}.liquid"
    elsif template_engine == :haml
      template "layout.html.haml", "#{theme_views_layout}/#{theme_name}.html.haml"
    else
      template "layout.html.erb", "#{theme_views_layout}/#{theme_name}.html.erb"
    end
  end

  private

    def theme_directory
      "app/themes/#{theme_name}"
    end
    
    def theme_views_layout
      "#{theme_directory}/views/layouts"
    end

    def theme_images_directory
      "#{theme_directory}/assets/images/#{theme_name}"
    end

    def theme_javascripts_directory
      "#{theme_directory}/assets/javascripts/#{theme_name}"
    end

    def theme_stylesheets_directory
      "#{theme_directory}/assets/stylesheets/#{theme_name}"
    end

    def theme_locales_directory
      "#{theme_directory}/locales"
    end
end
