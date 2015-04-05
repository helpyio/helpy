namespace :mailbox do

  desc "Fetch mail from remote emailbox"
  task :check => :environment do
    Topic.fetch_email
  end

end
