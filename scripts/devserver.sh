#!/bin/bash
SUCK_DB=true
REFRESH_DB=true
START_SERVER=true
VERBOSE=false
CLEANUP_AFTER=true

PROJECT_NAME='helpy'
LIVE_SERVER="help.achi.tech"
LIVE_DATABASE="helpy_production"
LIVE_USERNAME='helpy'
TEMP_BACKUP='production.dump'
DEV_SERVER='127.0.0.1'
DEV_DATABASE="helpy_development"
DEV_PASSWORD='password'
DEV_USERNAME="tmerritt"

function suck_db() {
  if [ $VERBOSE ]; then
    printf "\n\tStarting to sync database $LIVE_DATABASE from $LIVE_SERVER to $DEV_DATABASE locally"
    printf "\n\t- Dumping Database $LIVE_DATABASE..."
  fi
  ssh $LIVE_USERNAME@$LIVE_SERVER "pg_dump -c --no-owner -x -w --no-security-labels -U $LIVE_USERNAME -d $LIVE_DATABASE" > production.dump
}

function refresh_db() {
  if [ $VERBOSE ]; then
    printf "\n\t- Maintain Local Database $DEV_DATABASE..."
  fi
  PGPASSWORD=$DEV_PASSWORD dropdb $DEV_DATABASE -h $DEV_SERVER
  PGPASSWORD=$DEV_PASSWORD createdb $DEV_DATABASE -h $DEV_SERVER
  if [ $VERBOSE ]; then
    printf "Done\n\t- Restore Local Database $DEV_DATABASE..."
  fi
  PGPASSWORD=$DEV_PASSWORD psql -U $DEV_USERNAME $DEV_DATABASE -h $DEV_SERVER -f production.dump
}

function start_server() {
  if [ $VERBOSE ]; then
    printf "\n\t- Applying Development Database Changes"
  fi
  rake db:migrate
  if [ $VERBOSE ]; then
    printf "\n\tStarting Development Server\n"
  fi
  rails s -b 0
}

function cleanup_after() {
  if [ -f $TEMP_BACKUP ]; then
     rm $TEMP_BACKUP
  fi
}

clear
printf "Launching $PROJECT_NAME"
if [ $SUCK_DB ]; then
  suck_db
fi

if [ $REFRESH_DB ]; then
  refresh_db
fi

if [ $START_SERVER ]; then
  start_server
fi

if [ $CLEANUP_AFTER ]; then
  cleanup_after
fi
