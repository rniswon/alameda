@echo off
echo colrow=no           > settings.fig
echo date=mm/dd/yyyy    >> settings.fig


REM __________________________________________________________________________________________________
REM
REM  

REM                            %1    %2    %3    %4     %5      %6      %7      %8       %9
REM                            --    --    --    --     --      --      --      --       --
call 01_Sub.ArrayBuild.bat    HydKh  L_1   L_2   L_3    L_4    Lay_1   Lay_2   Lay_3   Lay_4    


REM call 01_Sub.ArrayBuild_SK.bat SurfK  L_1   L_2   L_3    L_4    Lay_1   Lay_2   Lay_3   Lay_4    


echo .
echo *********************************************
echo Finished Interpolating Pilot Points to Arrays
echo *********************************************
echo .
