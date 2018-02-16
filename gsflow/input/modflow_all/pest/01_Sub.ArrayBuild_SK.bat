@echo off
REM echo colrow=no           > settings.fig
REM echo date=mm/dd/yyyy    >> settings.fig
REM copy settings.fig    .\Arrays  > nul
REM copy t.GridSpecs.txt .\Arrays  >  nul

REM __________________________________________________________________________________________________

REM  The following is a key for what parameters were passed to this file.
REM  %1  :: SurfK
REM  %2  :: L_1
REM  %3  :: L_2
REM  %4  :: L_3
REM  %5  :: L_4
REM  %6  :: Lay_1
REM  %7  :: Lay_2
REM  %8  :: Lay_3
REM  %9  :: Lay_4

REM  Next, specify the parameters required by the called upon batch file.
REM   %1    Enter name of interpolation factor file:                                 
REM   %2    Enter name of pilot points file [points.dat]:  ---  File altered by PEST 
REM   %3    Enter name for output real array file:                                   

REM For Surface K (regulate surface discharge) of layer 1
REM ------------------------------------------

call 02_Sub.PP2Layer.bat      .\Alameda-Interpolated_%1_%2_By_ppk2fac.txt    .\%1_PP_List.txt      ..\uzf_support\%1.txt 
cd ..\uzf_support\
echo  702  771        >   RefArr_In.txt
echo  %1.txt         >>   RefArr_In.txt
call ReformArray.exe <    RefArr_In.txt
cd ..\pest\





REM REM For Specific Yield of layers 2 & 3
REM REM ----------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\%1_SY_PP_List.txt     ..\%1_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For Specific Yield of layers 4 & 5
REM REM ----------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%8_By_Pest.txt    ..\%2_SY_PP_List.txt     ..\%2_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For Specific Yield of layer 6
REM REM -----------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%9_By_Pest.txt    ..\%3_SY_PP_List.txt     ..\%3_SY_MF_Input_Array.txt  SpYld
REM 
REM REM For THTS (Theta_Sat) of Unsaturated Zone
REM REM ----------------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\UnsatZn_THTS_PP_List.txt     ..\THTS_UZF_Input_Array.txt  THTS
REM 
REM REM For THTR (Theta_Residual) of Unsaturated Zone
REM REM ---------------------------------------------
REM 
REM call 02_Sub.PP2Layer.bat     ..\MCR-Interpolated_%7_By_Pest.txt    ..\UnsatZn_THTR_PP_List.txt     ..\THTR_UZF_Input_Array.txt  THTR
REM 