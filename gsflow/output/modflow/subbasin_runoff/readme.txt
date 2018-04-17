4/10/2018
This utility supports calculating simulated runoff from a steady state GSFLOW model of the Alameda basin. Runoff is subtracted
from total runoff at gage locations to calculate simulated baseflow. Overland flow is summed for each stream segment and lake and then
runoff is summed for each by subbasin. Values are read from the SFR2 stream listing output file. 
Segments receive runoff from UZF using IRUNBND. Baseflow is calculated outside this program (get_runoff) by subtracting
these runoff values from the total flows output to gage files.

required input files are:
SFR_streams.out (SFR2 stream listing output file)
subbasin.txt (list of segments and associated subbasins)
subbasin_trib.txt (number of tributary subbasins for each subbasin and list of tributary subbasin numbers)
subbasin_lake.txt (lake number followed by subbasin gage lake discharges to)
names_lake_gage_files.txt (lake number followed by list of gage output files for lakes)

Output files:
runoff.out (stream and lake runoff by subbasin, including tributary subbasins)
info.out (diagnostic output file)