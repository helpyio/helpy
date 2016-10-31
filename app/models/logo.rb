class Logo

  extend CarrierWave::Mount
  attr_accessor :file
  mount_uploader :file, LogoUploader

  def save
    self.store_file!
  end

end
