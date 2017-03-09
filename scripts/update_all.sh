#!/usr/local/bin/bash

export TROOT=/disk/lif2/bwgref/git/nustar_trend_plots


cd $TROOT
echo "Updating trend data." > update.log
now=`date`
echo $now >> update.log
./update_trends.sh >> update.log 2>&1
./temperature_trends.sh >> update.log 2>&1
./dump_data.sh >> update.log 2>&1
./push_slack.sh update.log >> /dev/null