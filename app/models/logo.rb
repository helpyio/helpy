class Logo
  extend CarrierWave::Mount
  attr_accessor :file
  mount_uploader :file, LogoUploader

  def save
    store_file!
  end
end
