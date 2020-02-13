#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SLEEPSECONDS=5
echo "waiting $SLEEPSECONDS seconds for postgres.."

# sleep while postgres is initializing
sleep $SLEEPSECONDS
echo "before checking for postgres"
until pg_isready -q -h $POSTGRES_HOST
do
    echo "."
    sleep 1
done
sleep 2

echo "postgres is now available"

RUN_PREPARE=${DO_NOT_PREPARE:-false}

if [[ "$RUN_PREPARE" = "false" ]]
  then
    echo "DO_NOT_PREPARE is not set or is false, preparing.."
    # only necessary for first install
    echo "Installing Helpy Cloud"
    bundle exec rake helpy_cloud_engine:install:migrations
    echo "Migrate again"
    bundle exec rake db:migrate
    echo "Seeding"
    bundle exec rake db:seed || echo "db is already seeded"
    echo "Install Helpy Cloud assets"
    bundle exec rails g helpy_cloud:install
    echo "Precompilation"
    bundle exec rake assets:precompile
    nohup bundle exec rake helpy:mailman mail_interval=30 &
fi

echo "starting unicorn"
mkdir -p log
touch log/production.log

exec bundle exec unicorn -E production -c config/unicorn.rb
