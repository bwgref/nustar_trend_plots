#!/usr/bin/bash

# Adjust for local environment if not running on LIF or if running
# as another user.
#source $NUSTARSETUP
#export TRENDROOT=/disk/lif2/bwgref/git/
export IDL_DIR=/usr/local/idl8.7/idl
export IDL_STARTUP=$TROOT/setup/idl_ran.pro

IDL_LOC=/usr/local/idl8.7/idl/bin
${IDL_LOC}/idl -quiet dump_data.bat


mv *txt ../output



