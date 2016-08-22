# encoding: utf-8
GrapeSwaggerRails.options.before_filter_proc = proc {
  GrapeSwaggerRails.options.app_url = request.protocol + request.host_with_port
  unless current_user && current_user.is_agent?
    redirect_to(request.protocol + request.host_with_port)
  end
}
GrapeSwaggerRails.options.url       = "/swagger_doc.json"
GrapeSwaggerRails.options.app_name  = "Helpy API"
GrapeSwaggerRails.options.api_key_name = 'token'
