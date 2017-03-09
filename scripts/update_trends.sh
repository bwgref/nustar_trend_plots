#!/usr/local/bin/bash

#source /users/bwgref/.bash_profile
# SOC setup
export HOME=/users/bwgref
source /users/bwgref/SOC_setup_FLT.sh
export IDL_STARTUP=$HOME/idl/idl_lif.pro
# IDL startup for batch jobs
#export IDL_STARTUP=$L1SCRIPTS/idl/startup/defb.pro

IDL_DIR=/usr/local/rsi/idl71/bin
${IDL_DIR}/idl -quiet update_trends.bat


