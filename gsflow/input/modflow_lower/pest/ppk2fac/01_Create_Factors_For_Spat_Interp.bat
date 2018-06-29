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


Call  02_Sub.Create_Factors_For_Spat_Interp_vks.bat  ..\Alameda_GridSpecification.txt    vks   1
echo .
echo *******************************************************************************************************************
echo Finished Interpolating Pilot Points and Writing New "Factor" File For vks (partition infiltration/recharge)
echo *******************************************************************************************************************
echo .
