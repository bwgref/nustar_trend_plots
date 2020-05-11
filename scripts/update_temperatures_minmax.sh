#!/usr/bin/bash


# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_lif.pro


IDL_LOC=/usr/local/bin
${IDL_LOC}/idl -quiet update_temperatures_minmax.bat


