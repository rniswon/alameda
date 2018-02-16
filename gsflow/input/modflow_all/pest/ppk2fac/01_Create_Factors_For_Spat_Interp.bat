@echo off

REM   %1    Model name 
REM   %2    Structure name and final array label in file name
REM   %3    Layer number

Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Alameda_GridSpecification.txt    HydKh_L_1   1
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 1 Horz. K
echo **************************************************************************************
echo .


Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\alameda_GridSpecification.txt    HydKh_L_2   2
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 2 Horz. K
echo **************************************************************************************
echo .


Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Alameda_GridSpecification.txt    HydKh_L_3   3
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 3 Horz. K
echo **************************************************************************************
echo .


Call  02_Sub.Create_Factors_For_Spat_Interp_K.bat  ..\Alameda_GridSpecification.txt    HydKh_L_4   4
echo .
echo **************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 4 Horz. K
echo **************************************************************************************
echo .


REM 
REM REM echo .
REM REM echo **************************************************************************************
REM REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For Layer 2 Horz. K
REM REM echo **************************************************************************************
REM REM echo .
REM 
REM Call  02_Sub.Create_Factors_For_Spat_Interp_surfK.bat  ..\Carmel_GridSpecification.txt    SurfK   1
REM echo .
REM echo *******************************************************************************************************************
REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For Surface K (partition infiltration/recharge)
REM echo *******************************************************************************************************************
REM echo .
REM 
REM Call  02_Sub.Create_Factors_For_Spat_Interp_vks.bat    ..\Carmel_GridSpecification.txt    vks   1
REM echo .
REM echo *******************************************************************************************************************
REM echo Finished Interpolating Pilot Points and Writing New "Factor" File For vks (vert. hydraulic K in unsat zone)
REM echo *******************************************************************************************************************
REM echo .
