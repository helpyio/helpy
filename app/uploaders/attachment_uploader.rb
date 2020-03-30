class AttachmentUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  def self.set_storage
    if ENV['REMOTE_STORAGE'] == "true"
      :fog
    else
      :file
    end
  end

  storage set_storage

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_blacklist
    AppSettings['settings.extension_blacklist'].split(',').map(&:strip) if AppSettings['settings.extension_blacklist'].present?
  end

  def extension_whitelist
    AppSettings['settings.extension_whitelist'].split(',').map(&:strip) if AppSettings['settings.extension_whitelist'].present?
  end

end
