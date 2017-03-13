# nustar_trend_plots

Repo to produce the NuSTAR trend plots. In the ./output subdirectory there's a Veusz script along with (what's supposed to be) the most
recent version of the output text files. Those text files should be automatically updated by a cron job that runs on the 1st and 15th of each month on LIF.

You just need to open the Veusz script, which should autoload the most recent data, dump the result to PDF, then copy this file to the trend_plot directory on the web server.
