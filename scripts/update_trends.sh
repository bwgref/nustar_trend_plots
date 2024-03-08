#!/usr/bin/bash

#source /users/bwgref/.bash_profile
# SOC setup
#export HOME=/users/bwgref
#source /users/bwgref/SOC_setup_FLT.sh

# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_ran.pro


#export IDL_STARTUP=$L1SCRIPTS/idl/startup/defb.pro
IDL_LOC=/usr/local/idl8.7/idl/bin
${IDL_LOC}/idl -quiet update_trends.bat
