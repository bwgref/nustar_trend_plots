#!/usr/local/bin/bash

cd /users/bwgref/update_trends
echo "Updating trend data." > update.log
now=`date`
echo $now >> update.log
./update_trends.sh >> update.log 2>&1
./temperature_trends.sh >> update.log 2>&1
./dump_data.sh >> update.log 2>&1
./push_slack.sh update.log >> /dev/null