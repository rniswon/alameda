REM  Preprocessing routines

REM  Interpolate Kh, SurfK (all contained in one batch routine)
cd    .\INPUT\modflow_all\pest\
call  00_MF_Call_Array_Build.bat
cd    ..\..\..\

REM  Scale finf by subasin (original finf array multiplied by scaling array)
cd    .\INPUT\modflow_all\uzf_support\
call  twoarray.exe    < twoarray.in
call  ReformARRAY.exe < RefArr_In_finf.txt
cd    ..\..\..\

REM  Call model runfile
MF_NWT.exe alameda_all.nam

REM  Perform post-processing routine #1
cd    .\OUTPUT\
call  obs2obs.exe obs2obs.in obs2obs.out
cd    ..\




