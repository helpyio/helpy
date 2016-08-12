class Theme
  cattr_accessor :cache_theme_lookup
  @@cache_theme_lookup = false

  attr_accessor :name, :path, :description_html

  def initialize(name, path)
    @name = name
    @path = path
  end

  def layout(action = :default)
    if action.to_s == 'view_page'
      if File.exist? "#{::Rails.root}/themes/#{name}/views/layouts/#{name}.html.erb"
        return 'layouts/pages'
      end
    end
    'layouts/default'
  end

  def description
    about_file = "#{path}/about.markdown"
    if File.exist? about_file
      File.read about_file
    else
      "### #{name}"
    end
  end

  def thumbnail
    "#{name}.png"
  end

  # Find a theme, given the theme name
  def self.find(name)
    new(name, theme_path(name))
  end

  def self.themes_root
    ::Rails.root.to_s + '/app/themes'
  end

  def self.theme_path(name)
    File.join(themes_root, name)
  end

  def self.theme_from_path(path)
    name = path.scan(/[-\w]+$/i).flatten.first
    new(name, path)
  end

  def self.find_all
    installed_themes.map do |path|
      theme_from_path(path)
    end
  end

  def self.installed_themes
    cache_theme_lookup ? @theme_cache ||= search_theme_directory : search_theme_directory
  end

  def self.search_theme_directory
    glob = "#{themes_root}/[a-zA-Z0-9]*"
    Dir.glob(glob).select do |file|
      File.readable?("#{file}/about.markdown")
    end.compact
  end
end
