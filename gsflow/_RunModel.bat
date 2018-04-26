REM  Preprocessing routines

REM  Interpolate Kh, SurfK (all contained in one batch routine)
cd    .\INPUT\modflow_all\pest\
call  00_MF_Call_Array_Build.bat
cd    ..\..\..\

REM  Reformat the FINF & pET scaling arrays from a single column to array format
cd    .\INPUT\modflow_all\uzf_support\
call  ReformARRAY.exe < RefArr_In_scale_finf.txt
call  ReformARRAY.exe < RefArr_In_scale_pET.txt

REM  Also, reformat the surfK array from a single column to array format
call  ReformARRAY.exe < RefArr_In_surfK.txt

REM  Scale finf by subasin (original finf array multiplied by scaling array)
call  twoarray.exe    < twoarray_finf.in
call  ReformARRAY.exe < RefArr_In_finf.txt

REM  Scale pET by subasin (original pET array multiplied by scaling array)
call  twoarray.exe    < twoarray_pET.in
call  ReformARRAY.exe < RefArr_In_pET.txt
cd    ..\..\..\

REM  Call model runfile
MF_NWT.exe alameda_all.nam

REM  Perform post-processing routine #1
cd    .\OUTPUT\modflow\subbasin_runoff\
call  get_runoff.exe
cd    ..\

REM  Peel-out GWET from .lst file for multiplying by 365
call  inschek.exe  alameda.lst.ins alameda.lst

REM  Multiply GWET from .lst file by 365 for comparing to derived observation value
call  obs2obs.exe  obs2obs_GWET.in obs2obs_GWET.out

call  obs2obs.exe  obs2obs.in obs2obs.out
cd    ..\..\







