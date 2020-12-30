module RtlConcern
  extend ActiveSupport::Concern
  include ApplicationHelper

  def render(*args)
    super(*args) and return unless rtl?
    super(*args) and return unless has_rtl_view?

    options = args.extract_options!
    options[:template] = "#{params[:controller]}/rtl/#{params[:action]}"
    super(*(args << options))
  end

  def has_rtl_directory?
    return false if params[:controller].empty?

    Dir.exist?(File.join(root_directory, 'app', 'views', params[:controller], 'rtl'))
  end

  def has_rtl_action?
    return false if params[:controller].empty? || params[:action].empty?

    File.exist?(File.join(root_directory, 'app', 'views', params[:controller], 'rtl', action_filename))
  end

  def root_directory
    File.expand_path(Rails.root)
  end

  def action_filename
    params[:action].to_s + view_files_format
  end

  def view_files_format
    '.html.erb'
  end

  def has_rtl_view?
    has_rtl_directory? && has_rtl_action?
  end
end
