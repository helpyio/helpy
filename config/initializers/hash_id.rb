Hashid::Rails.configure do |config|
  # The salt to use for generating hashid. Prepended with table name.
  config.salt = 'salt'

  # The minimum length of generated hashids
  config.min_hash_length = 12

  # The alphabet to use for generating hashids
  config.alphabet = "abcdefghijklmnopqrstuvwxyz" \
                    "ABCDEFGHIJKLMNOPQRSTUVWXYZ" \
                    "1234567890"

  # Whether to override the `find` method
  config.override_find = false

  # Whether to sign hashids to prevent conflicts with regular IDs (see https://github.com/jcypret/hashid-rails/issues/30)
  config.sign_hashids = true
end