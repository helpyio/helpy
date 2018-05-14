#!/bin/bash
source $(dirname $0)/VARS
printf "\n\t- Maintain Local Database $DEV_DATABASE..."
echo "PASS SET TO $DEV_PASSWORD"
PGPASSWORD=$DEV_PASSWORD dropdb $DEV_DATABASE -h $DEV_SERVER
echo "DROP DB COMPLETE"
PGPASSWORD=$DEV_PASSWORD createdb $DEV_DATABASE -h $DEV_SERVER
echo "CREATE DB COMPLETE"
printf "Done\n\t- Restore Local Database $DEV_DATABASE..."
PGPASSWORD=$DEV_PASSWORD pg_restore --no-acl --no-owner -d $DEV_DATABASE -h $DEV_SERVER production.dump
