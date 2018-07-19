#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

SLEEPSECONDS=5
echo "waiting $SLEEPSECONDS seconds for postgres.."

# sleep while postgres is initializing
sleep $SLEEPSECONDS
pg_isready -q -h postgres
ISREADY=$?
while [[ "$ISREADY" != 0 ]]; do
  pg_isready -q -h postgres
  let ISREADY=$?
  echo "waiting $SLEEPSECONDS seconds for postgres.."
  sleep $SLEEPSECONDS
done

echo "postgres is now avaliable"

RUN_PREPARE=${DO_NOT_PREPARE:-false}

if [[ "$RUN_PREPARE" = "false" ]]
  then
    echo "DO_NOT_PREPARE is not set or is false, preparing.."
    bundle exec rake assets:precompile
    bundle exec rake db:migrate
    bundle exec rake db:seed || echo "db is already seeded"
fi

echo "starting unicorn"

exec bundle exec unicorn -E production -c config/unicorn.rb
