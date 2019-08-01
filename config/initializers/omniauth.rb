# Allow only POST to mitigate CVE-2015-9284, see 
# https://github.com/omniauth/omniauth/wiki/Resolving-CVE-2015-9284
# TODO: remove once https://github.com/omniauth/omniauth/pull/809 is resolved
OmniAuth.config.allowed_request_methods = [:post]