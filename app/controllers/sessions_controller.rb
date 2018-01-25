class SessionsController < Devise::SessionsController
  theme :theme_chosen

  # prevents locale from getting carried over- see https://github.com/plataformatec/devise/issues/3569
  prepend_before_action :require_no_authentication, :only => [ :new, :create ]
  prepend_before_action :allow_params_authentication!, :only => :create
  prepend_before_action { request.env["devise.skip_timeout"] = true }
  prepend_before_action :set_locale
  after_action :reset_locale

end
