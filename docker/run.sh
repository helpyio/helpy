#!/bin/bash

set -euo pipefail
IFS=$'\n\t'

echo "starting unicorn"
mkdir -p log
touch log/production.log

exec bundle exec unicorn -E production -c config/unicorn.rb
