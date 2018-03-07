#!/usr/local/bin/bash


# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_lif.pro


IDL_LOC=/usr/local/rsi/idl71/bin
${IDL_LOC}/idl -quiet update_metrology.bat


