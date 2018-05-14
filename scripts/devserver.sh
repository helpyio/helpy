#!/bin/bash
clear
source $(dirname $0)/VARS
printf "***  Preparing to launch Dev Server  ***"
scripts/suckdb.sh
scripts/refreshdb.sh
printf "\n\t- Applying Development Database Changes"
rake db:migrate
printf "\n\tStarting Development Server\n"
rails s -b 0
