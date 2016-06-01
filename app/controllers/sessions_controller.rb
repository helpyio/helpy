class SessionsController < Devise::SessionsController
  theme :theme_chosen
  layout :which_layout, only: 'new'

  def new
    super
  end

  protected

  def which_layout
    if AppSettings['theme.active'] == 'helpy'
      'devise'
    else
      AppSettings['theme.active']
    end
  end

end
