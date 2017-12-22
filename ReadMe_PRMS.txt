Changed streamflow, rainfall, and temperature data in order to have 8 AM to 8 AM days in which 
the printed date is the date of the start of the 24-hr period.
In terms of parameters run 49 is same as run 43.
Run50, carea_max was changed to 0.5 from its original value of 0.
Run51: Additionally soil_moist_Max for Alameda watershed was divided by 1.15 and then multiplies by 1.5 to make it consistent with Arroyo Hondo between Run 20 and 30. 
Again for entire watershed  soil_moist_max was multiplied by 1.2. Simulated volume on average is larger than observed volume. This step is expected make the difference narrower.
About 8000 grid cells have soil_moist_max values > 10, and were changed to 10 according to PRMS manual. 

Run52: Considering how flow values changed in run 51 in 1997 and 1998 the maximum values of soil_moist_max were changed to 100. soil_moist_init was greater than soil_moist_max, therefore this was done.
Run53: soil_moist_max was again multiplied by 1.15.
Run54: To make average annual water balace close soil_moist_max for Alameda Creek watershed was divided by 1.1.
Run55: Multiplied sat_threshold by 3. Resulted values greater than 999 were reduced to 999 based on suggested maximum value in the manual. This took flows down a little bit but not too much. It was almost insignificant.
Run56: It was found that many HRUs had soil_threhold of zero. In existing data average soil_threhold was 46 so first zero soil_threhold values were changed to 50. Then soil_theshold was mulitplied by 10 for all HRUs but maximum value was limited to 999.
This reduced Dunnian flow significantly so the surface runoff and increased interflow by the same amount. Hydrographs were not very different.
Run57:Soil_Moist_Max was found to be zero same as sat_thershold in many Hrus. Those 0s were changed to 10.
Run58:For Hru with Slowcoef_lin zero values were changed to 0.001. All other slowcoef_lin values were divided by 10. 
Run59: Started with run 54. It was found that many HRUs had soil_threhold of zero. In run 54 average soil_threhold was 20 so zero soil_threhold values were changed to 20.Soil_Moist_Max was found to be zero same as sat_thershold 
in many Hrus. Those 0s were changed to 10.
Run60: Soil2GW_max values were zero. Changed to maximum value of 5. This generated enormous amount of groundwater flow.
Run61: In run 59 soil2GW_max was changed to value of 0.5. 
Run62: In run 59 soil2GW_max was changed to value of 0.1. 
Run63: Satrted with run 54. It was found that many HRUs had soil_threhold of zero. So zero soil_threhold values were changed to 1 (minimum recommended).Soil_Moist_Max was found to be zero same as sat_thershold in many Hrus. 
Those 0s were changed to 0.001 (minimum recommended).
Run 64: Started with run 54.Changed pref_flow_den to 0.4 from original value of 0.2. This increased surface runoff (dunnian runoff and interflow) and reduced groundwater flow. Caused higher peaks even during early season.
Run 65: Started with run 54.Changed pref_flow_den to 0.05 from original value of 0.2. This reduced surface runoff a little bit. However, this increases hortonian flow and reduction primarily comes from reduction in Dunnian flow.
Run 66: In run 57 sat_threhold was multiplied by 2 for Arroyo Hondo watershed but maximum value was retained as 999. This is done to reduce surface flow in Arroyo Hondo.
Run 67: In run 57 sat_threhold was multiplied by 10 for Arroyo Hondo watershed but maximum value was retained as 999. This is done to reduce surface flow in Arroyo Hondo.
Run 68: In run 57 sat_threhold was set to 999 for Arroyo Hondo watershed.This is done to reduce surface flow in Arroyo Hondo.
Run 69: In run 68 carea_max was changed to 0.2 (from 0.5).
Run 70: In run 67, the rainfall zonation was changed. Primarily San Antonio rain gage was used to distribute rainfall across San Antonio watershed.
Run 71: In Run 70, sat_threhold was set to 999 for Arroyo Hondo watershed. carea_max was changed to 0.05 (from 0.5).
Run 72: In Run 69, slowcoef_sq was changed to 0.2 from existing value of 0.1.Soil_moist_max for Indian Cr (watshd =1), San Antonio Cr (watshd =2)at Indian Rd, and San Antonio Cr(watshd =4) was mulitplied by 1.5.
Changed GW_sink-coed for Alameda Cr Abv San Antonio Cr (wathsd = 11) to 0.5 (from existing value of zero) and Alameda Cr Abv Arroyo de la Laguna (wathsd = 12) to 0.25
Run 73: In Run 72, slowcoef_sq was changed back to 0.1.Soil_moist_max for Indian Cr (watshd =1), San Antonio Cr (watshd =2)at Indian Rd, and San Antonio Cr(watshd =4) was agaian mulitplied by 2.Carea_max was changed to 0.
Changed GW_sink-coed for Alameda Cr Abv San Antonio Cr (wathsd = 11) to 1.0 (from existing value of zero) and Alameda Cr Abv Arroyo de la Laguna (wathsd = 12) to 1.0
Run74: In Run 73, sat_threshold were taken from Run 54. Frist zeros sat_threhold from Run 54 were chaged to avarage value of 20. Then sat_theshold was multiplied by 15. Maximum value was retained to 999. This was done to 
generate some surface flows as no surface flows were generated in Run 73.
Run75: In Run 74, sat_threshold were divided by 2. 
Run76: In Run 75, Carea_max was changed to 0.05 (from zero).
Run77: In Run 76, Carea max for Indian and San Antonio Creeks were changed to 0.02, Arroyo Hondo to 0.075, and Alameda Creek watershed to 0.1 
Run78: In Run 77, Pref_flow_den was changed to 0.4 from 0.2
Run79: In Run 78, Pref_flow_den was changed to 0.3, 0.5, and 0.45 for San Antonio Cr watershed, Alameda Creek watershed, and rest of the watersheds, respectively.
Run 82: Started with run 78 and changed hru_subbasin in the parameter file to make sure that all grid cells outside of the model domain had a value of 0.



Matlab runs: 
Same as run 82, but now trying to use Chris' incremental calibration code.  Also moved soil2gw_max from default parameter file to calibration parameter file.

After 1st group of Matlab runs, changed base rain_adj values in run 82 parameter file (using separate R code) so that values < 0.5 are set equal to 0.5 and 
values > 2 are set equal to 2