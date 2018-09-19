# ClientSideValidations Initializer

# Disabled validators. The uniqueness validator is disabled by default for security issues. Enable it on your own responsibility!
# ClientSideValidations::Config.disabled_validators = [:uniqueness]

# Uncomment to validate number format with current I18n locale
# ClientSideValidations::Config.number_format_with_locale = true

# Uncomment the following block if you want each input field to have the validation messages attached.
#
# Note: client_side_validation requires the error to be encapsulated within
# <label for="#{instance.send(:tag_id)}" class="message"></label>

ActionView::Base.field_error_proc = Proc.new do |html_tag, instance|
  unless html_tag =~ /^<label/
    %{<div class="field_with_errors">#{html_tag}<label for="#{instance.send(:tag_id)}" class="message">#{instance.error_message.first}</label></div>}.html_safe
  else
    %{<div class="field_with_errors">#{html_tag}</div>}.html_safe
  end
end

module ClientSideValidations
  module ActionView
    module Helpers
      module FormHelper
        def construct_validators
          @validators.each_with_object({}) do |object_opts, validator_hash|
            option_hash = object_opts[1].each_with_object({}) do |attr, result|
              result[attr[0]] = attr[1][:options]
            end

            validation_hash =
              if object_opts[0].respond_to?(:client_side_validation_hash)
                object_opts[0].client_side_validation_hash(option_hash)
              else
                {}
              end

            option_hash.each_key do |attr|
              # attr is String type which is different type of validation_hash's keys
              validation_hash = validation_hash.with_indifferent_access
              if validation_hash[attr]
                validator_hash.merge!(object_opts[1][attr][:name] => validation_hash[attr])
              end
            end
          end
        end
      end
    end
  end
end

