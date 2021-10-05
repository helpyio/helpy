environment ENV.fetch 'RAILS_ENV', 'production'

threads 0, 16

bind 'tcp://0.0.0.0:3000'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end