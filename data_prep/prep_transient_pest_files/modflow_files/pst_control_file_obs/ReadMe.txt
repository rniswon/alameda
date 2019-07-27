The manual updates to streamflow_obs_for_pst that were made in streamflow_obs_for_pst_manual_updates were the
following:
1) removed s13 (Arroyo de la Laguna) because it's a boundary condition, not an observation
2) added a row for s1 and s2 (Indian Creek and San Antonio Creek at Indian Creek Rd) with missing data code as a place holder 
because it was removed in the R analysis since it didn't have any non-missing min/max values
3) changed the weight for s1 - s7 to 0 since they are in the upper watershed