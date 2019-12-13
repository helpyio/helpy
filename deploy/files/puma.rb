# Puma "clustering" means multiple "workers" running along with a master process
# Within each worker, ruby threads run a copy of the app, assuming tread safe app
# workers in os processes run concurrently up to 3-4x cpu cores. More good info:
#   see https://www.youtube.com/watch?v=itbExaPqNAE
# ruby threads take turns (GIL)

# each worker runs puma server
workers Integer(ENV['PUMA_CONCURRENCY'] || 1)

# ruby threads handle requests within each worker
threads_count = Integer(ENV['PUMA_THREADS'] || 1)
threads threads_count, threads_count                # min and max set the same

# store app to spawn ruby threads more quickly, recommended for cluster mode
preload_app!

rackup      DefaultRackup
port        ENV['PORT']     || 3000
environment ENV['RACK_ENV'] || 'development'

before_fork do
  if Rails.env.production?
    require 'puma_worker_killer'                    # https://github.com/schneems/puma_worker_killer
    PumaWorkerKiller.config do |config|
      config.ram           = Integer(ENV['PWK_RAM'] || 2048) # available server memory
      config.frequency     = 30                     # Check the situation every seconds
      config.percent_usage = 0.90                   # Keep some headroom
      config.rolling_restart_frequency = 6 * 3600   # 6 hours in seconds             # not using rolling restarts
      config.reaper_status_logs = true              # To write log lines like:
                                                    # PumaWorkerKiller: Consuming 845.1328125 mb with master and 6 workers.
      # config.pre_term = -> (worker) { puts "Puma worker #{worker.inspect} being killed" }
      config.pre_term = -> (worker) { puts "Puma worker being killed" }
    end
    PumaWorkerKiller.start                          # get the show on the road
  end
  # see https://github.com/puma/puma
  ActiveRecord::Base.connection_pool.disconnect!
end

on_worker_boot do
  # Worker specific setup for Rails 4.1+
  # See: https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
  ActiveRecord::Base.establish_connection
  puts ">>>>>>>>>>>>>>>>>>>> puma worker boot <<<<<<<<<<<<<<<<<<<<"
end