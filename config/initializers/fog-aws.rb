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
    config.fog_credentials = {
      provider:              'AWS',
      aws_access_key_id:     'ZXOTITSJ4PBC2PGOSLYL',
      aws_secret_access_key: 'owmyetDSO18wKJaAY4kKwJa/daYj8S9YRGbMabpGe9o',
      region:                'sfo2',
      endpoint:              'https://sfo2.digitaloceanspaces.com',
      # endpoint:            'https://s3.example.com:8080'
    }
    config.fog_directory  = 'helpy-spaces-test'
    config.fog_attributes = { cache_control: "public, max-age=#{365.day.to_i}" }
  end
end
