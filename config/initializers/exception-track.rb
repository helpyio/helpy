# frozen_string_literal: true

# require 'exception_notification/sidekiq'

ExceptionTrack.configure do
  # environments for store Exception log in to database.
  # default: [:development, :production]
  # self.environments = %i(development production)
end

# ExceptionNotification.configure do |config|
#   config.ignored_exceptions += %w(ActionView::TemplateError
#                                   ActionController::InvalidAuthenticityToken
#                                   ActionController::BadRequest
#                                   ActionView::MissingTemplate
#                                   ActionController::UrlGenerationError
#                                   ActionController::UnknownFormat)
# end
