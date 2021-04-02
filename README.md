# GHCN_extract

The GHCN_HTTPS function works to download climate observational data from the NOAA Global Historical Climate Network (GHCN) Daily database of meteorological observations. Some of these records date back to 1763.
------------------------------------------------------------------------------------------------------------------------------------------------------------

For more information on the GHCN-Daily data, see the documentation here: https://www.ncei.noaa.gov/data/global-historical-climatology-network-daily/doc/GHCND_documentation.pdf

See below for an example code for using this function:


1) Download the GHCN_HTTPS.m file and add it to your current path in matlab

addpath('your_path/GHCN_HTTPS.m')


2) Call function to download precipitation and snowfall records from around Washington, D.C. that contain at least 50 years of daily data
The station_list variable will store a MATLAB table data structure including information of the stations that have been downloaded to your directory

station_list = GHCN_HTTPS('your_save_path',{'PRCP','SNOW'},[38.8 39 -77.3 -76.8],50);


The data files (9 meeting the conditions) will now be stored at the specified path 'your_local_save_path' along with the station_list in your workspace. Snowfall and precipitation data are in millimeters. it will also be located in this location with the name _stationInfo.csv
