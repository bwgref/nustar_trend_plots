#!/usr/bin/bash

#source $NUSTARSETUP
source ~/SOC_setup_FLT.sh

export TROOT=/home/nustar1/nustar_git/nustar_trend_plots

cd $TROOT/scripts

echo "Updating trend data." > update.log
echo >> update.log
now=`date`
echo $now >> update.log
echo "Updating trends" >> update.log
./update_trends.sh >> update.log 2>&1
echo >> update.log


now=`date`
echo $now >> update.log
echo "Updating mean temperatures" >> update.log 2>&1
./update_temperatures.sh >> update.log 2>&1
echo >> update.log

now=`date`
echo $now >> update.log
echo "Updating min/max temperatures" >> update.log 2>&1
./update_temperatures_minmax.sh >> update.log 2>&1
echo >> update.log


now=`date`
echo $now >> update.log
echo "Generating output files" >> update.log 2>&1
./dump_data.sh >> update.log 2>&1
echo >> update.log

now=`date`
echo $now >> update.log
echo "Generating optics temperature" >> update.log 2>&1
./get_optics_temp.sh >> update.log 2>&1
# 

now=`date`
echo $now >> update.log
echo "Generating metrology info" >> update.log 2>&1
./update_metrology.sh >> update.log 2>&1


./push_slack.sh update.log >> /dev/null

cd $TROOT/output
git pull >> /dev/null
git add *txt >> /dev/null
git commit -m "Updated trend plot files..." >> /dev/null
git push > gitlog.log 2>&1 
