#!/usr/local/bin/bash

#source $NUSTARSETUP
source ~/SOC_setup_FLT.sh

export TROOT=/disk/lif2/bwgref/git/nustar_trend_plots

cd $TROOT/scripts
echo "Updating trend data." > update.log
now=`date`
echo $now >> update.log
./update_trends.sh >> update.log 2>&1
./update_temperatures.sh >> update.log 2>&1
./dump_data.sh >> update.log 2>&1
./push_slack.sh update.log >> /dev/null

cd $TROOT/output
git pull
git add *txt
git commit -m "Updated trend plot files..."
git push > gitlog.log
