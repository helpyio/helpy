CarrierWave.configure do |config|
  config.fog_provider = 'fog/aws'
  if Rails.env == 'test'
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      'secretkeyid',
      aws_secret_access_key:  'secretaccesskey',
      region:                 'abc',
      endpoint:               'ayz'
    }
    config.fog_directory =    'testbucket'

  else
    if ENV['REMOTE_STORAGE'] == "true"
      config.fog_credentials = {
        provider:              'AWS',
        aws_access_key_id:     ENV['S3_KEY'],
        aws_secret_access_key: ENV['S3_SECRET'],
        aws_signature_version: ENV['S3_SIG_VER'],
        region:                ENV['S3_REGION'],
        # host:                's3.amazon.com',
        endpoint:              ENV['S3_ENDPOINT'],
        path_style:            ENV['S3_PATH_STYLE'],
      }
      config.fog_directory  = ENV['S3_BUCKET_NAME']
      config.fog_public     = true
      config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" }
    end
  end
end
