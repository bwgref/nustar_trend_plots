#!/usr/bin/bash


# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_ran.pro


IDL_LOC=/usr/local/idl8.7/idl/bin
${IDL_LOC}/idl -quiet update_metrology.bat


