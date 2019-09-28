## UPDATING HELPY

In the default monolithic configuration, Helpy is a fairly standard Ruby on Rails app.  Updating to a new version requires several steps.  There are two main places you might want to get updates from:

1. The `master` branch, which is generally stable but is where most dev work happens and should be considered to be an *edge* version.  If you want to get the latest bleeding edge updates, pull from `master`
2. The release branches.  Here you can use the `release/stable` or specific version updates: ie `release/2.4.2` or `release/2.5.0`

Updating the community edition:

Whether you run the open source community edition or the cloud edition, start by updating the base app:

1. Get the latest version:
`git pull`

2. Update bundled gems:
`bundle install`

3. Run any new migrations, and update the assets:
`RAILS_ENV=production bundle exec rake db:migrate`
`RAILS_ENV=production bundle exec rake assets:precompile`

4. Restart the webserver.

### Helpy Pro Edition

Helpy Pro is a packaged version, which greatly simplifies the process of updating. Note that updated versions typically are not avaiable to Pro until several days after the community edition release.  Update using the apt package manager:

1. `sudo apt-get update`
2. `sudo apt-get upgrade`
3. `sudo helpy run db:migrate`
4. `sudo helpy restart`

### Cloud Edition 

If you are running the cloud edition, perform the following additional steps:

1. Update the cloud gem.  The major version should match the Helpy core major version.
`bundle update helpy_cloud`

2. Run the cloud installer:
`rails g helpy_cloud:install`

3. Update assets:
`RAILS_ENV=production bundle exec rake assets:precompile`

4. Restart webserver
