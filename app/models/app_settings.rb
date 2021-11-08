# == Schema Information
#
# Table name: settings
#
#  id         :integer          not null, primary key
#  var        :string           not null
#  value      :text
#  thing_id   :integer
#  thing_type :string(30)
#  created_at :datetime
#  updated_at :datetime
#

# RailsSettings Model
class AppSettings < RailsSettings::CachedSettings

  def self.get_logo
    @logo = Logo.new
    @logo.file.retrieve_from_store!(File.basename(AppSettings['design.header_logo']))
    @logo.file
  end

  def self.get_favicon
    @icon = Logo.new
    @icon.file.retrieve_from_store!(File.basename(AppSettings['design.favicon']))
    @icon.file
  end

end
