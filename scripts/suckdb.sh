#!/bin/bash
source $(dirname $0)/VARS
printf "\n\tStarting to sync database $LIVE_DATABASE from $LIVE_SERVER to $DEV_DATABASE locally"
printf "\n\t- Dumping Database $LIVE_DATABASE..."
ssh $LIVE_USERNAME@$LIVE_SERVER "pg_dump -U $DEV_USERNAME $LIVE_DATABASE" > production.dump
