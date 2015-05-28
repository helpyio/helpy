namespace :db do
  desc "Reset and populate the demo database"
  task :reset_demo_data => :environment do

    Rake::Task["db:reset"].execute
    Rake::Task["db:populate"].execute
  end
end
