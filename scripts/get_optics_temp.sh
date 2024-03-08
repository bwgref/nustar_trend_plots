#!/usr/bin/bash


# IDL startup for batch jobs
export IDL_STARTUP=$TROOT/setup/idl_ran.pro

#export IDL_STARTUP=$L1SCRIPTS/idl/startup/defb.pro
IDL_LOC=/usr/local/idl8.7/idl/bin
${IDL_LOC}/idl -quiet get_optics_temp.bat

mv *txt ../output

