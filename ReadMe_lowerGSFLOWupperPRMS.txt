MODFLOW INITIAL RUNS

Run 1: 
First run that mostly works.  Still need to address issues related to max lake stage in LAK package, UZF recharge, FINF values in UZF package, and GWET.
(See Rich's email from 3/29/17 for details.)


Run 2: 
Changed some values in SFR file related to getting outflow segments out of lakes 2, 7, and 8.  


Run 3: 
Changed KRCH value to 2 in all stream cells that are sitting on top of layer 2.  (Previously, all KRCH values had been set equal to 1 by default.) 
Also changed intial lake stage for all lakes so that the initial lake stage is 10 ft. below the max lake stage.  Changed FINF array in UZF file.  
Changed F3E bathymetry file.  Updated NAM file.  Fixed the units of FINF array in UZF file (converted them from inches to feet).  Tried changing FINF
multiplier value around.  Tried using ppt_sum_ft.  Now trying using ppt_sum_ftDay as FINF.


Run 4: 
Changed PET - increased it by 2 orders of magnitude to be about the same as measured ET in Davis, CA from a publication.  Set PET back to original value
(after trying orders of magnitude in between) because the transient model wouldn't converge.  Set all 0s in EXTDP to 3.


Run 5: 
Changed FINF values to ft/day.  Discovered that PRISM is in inches/month - so converted that to ft/day.  Started out with multiplication factor of 0.55 - 
but UZF recharge was still too low and GWET was also too low  

Tried changing FINF multiplier to 10, PET to 0.00256 (increased by an order of magnitude), and VKS multiplier to 0.5 (from 0.01) - 
now UZF recharge is 2 orders of magnitude too high and GWET is double what it should be.

Tried changing FINF multiplier to 0.55, PET to 0.00128, and VKS to 0.1 - now GWET is too low by ~25% and UZF recharge is 1 order of magnitude too high.

Tried leaving FINF multiplier alone, PET to 0.0016, and VKS to 0.05 - now GWET is too low by ~11% and UZF recharge is lower but still about 3x
too large.  And the steady state model converged!!!


Run 6: 
Tried leaving FINF multiplier alone, PET to 0.0018, and VKS to 0.01 - now GWET is oddly lower (too low by ~68%) and UZF recharge is too low by 19%.

Tried increasing FINF multiplier to 0.65, increasing PET to 0.002, and leaving VKS alone - now GWET is too low by ~66% and UZF recharge is still too low
by 19%.

Tried leaving FINF multiplier alone, increasing PET to 0.004, and increasing VKS to 0.03 - now GWET is within the desired range and UZF recharge is too high
by 116%.


Run 7:
Tried leaving FINF multiplier alone, leaving PET alone, and decreasing VKS to 0.02 - this made GWET too low by 24% but improved UZF recharge so that it is now 
too high by 55%.

Tried leaving FINF multiplier alone, leaving PET alone, and decreasing VKS to 0.015 - now GWET is too low by 36% but UZF recharge is too high by only 22%.

Tried increasing FINF multiplier to 0.75 (which gets the RCH/PPT ratio in the desired range), leaving PET alone, decreasing VKS multiplier to 0.013, and setting
SURFK multiplier to 0.013 as well - now GWET is too low by 25%, UZF recharge is within 2% (!!), but the percent discrepancy in the water budget is -15% 
(with more water leaving than entering).


Run 8:
Tried leaving FINF multiplier alone, leaving PET alone, leaving VKS multiplier alone, and changing SURFK to 0.01 - now GWET is too low by 24%, UZF
recharge is too high by 3%, and the percent discrepancy in the water budget is -16%.

Tried leaving FINF multiplier alone, increasing PET to 0.005, and leaving VKS and SURFK multipliers alone - now GWET is too low by 11%, UZF recharge is too
high by 2%, and the percent discrepancy in the water budget is -18%.

Tried leaving FINF multiplier alone, increasing PET to 0.006, and leaving VKS and SURFK multipliers alone - now GWET is too low by 11%, UZF recharge is too
high by 2%, and the percent discrepancy in the water budget is -18%.


Run 9: 
Experimental, not used, run 10 is based off of run 8


Run 10:
Rich lowered reservoir outflows to lower steady state lake stages


Run 11:
Changed DIS, LAK, and SFR files in order to match up lake min/max elevations with cell bottom elevations
