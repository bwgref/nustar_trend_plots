#!/usr/local/bin/bash


export HOME=/users/bwgref
source /users/bwgref/SOC_setup_FLT.sh
export IDL_STARTUP=$HOME/idl/idl_lif.pro

IDL_DIR=/usr/local/rsi/idl71/bin
${IDL_DIR}/idl -quiet dump_data.bat


