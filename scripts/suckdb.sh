#!/bin/bash
source $(dirname $0)/VARS
printf "\n\tStarting to sync database $LIVE_DATABASE from $SERVER to $DEV_DATABASE locally"
printf "\n\t- Dumping Database $LIVE_DATABASE..."
ssh $USERNAME@$SERVER "pg_dump -U $USERNAME $LIVE_DATABASE" > production.dump
