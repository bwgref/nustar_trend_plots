#!/usr/local/bin/bash

# Adjust for local environment if not running on LIF or if running
# as another user.


source $NUSTARSETUP

export TRENDROOT=/disk/lif2/bwgref/git/
export IDL_STARTUP=$TRENDROOT/idl/idl_lif.pro
export DATADIR=${TRENDROOT}/nustar_trend_plots

IDL_DIR=/usr/local/rsi/idl71/bin
${IDL_DIR}/idl -quiet dump_data.bat


