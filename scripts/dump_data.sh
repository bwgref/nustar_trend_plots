#!/usr/local/bin/bash

# Adjust for local environment if not running on LIF or if running
# as another user.
#source $NUSTARSETUP
#export TRENDROOT=/disk/lif2/bwgref/git/

export IDL_STARTUP=$TROOT/setup/idl_lif.pro

IDL_LOC=/usr/local/rsi/idl71/bin
${IDL_LOC}/idl -quiet dump_data.bat


mv *txt ../output



