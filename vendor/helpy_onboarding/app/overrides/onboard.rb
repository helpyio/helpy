# Add to the integrations panel
Deface::Override.new(
  :virtual_path  => "admin/topics/index",
  :insert_after => "div#tickets",
  :name          => "onboarding_modal",
  :partial => "admin/onboarding/onboarding_modal"
  )
