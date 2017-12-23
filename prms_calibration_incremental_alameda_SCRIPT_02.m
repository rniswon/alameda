% Clear/close out everything
clear
close all
clc

% Set working directory to folder containing this .m file
<<<<<<< HEAD
projectFolder = 'C:\gsflow_onlyPRMS_02';   % Will need to change this if running from other locations
=======
projectFolder = 'C:\gsflow_onlyPRMS_01';   % Will need to change this if running from other locations
>>>>>>> 94ef842b9f804b231bcbd21185ab0857ff7d93f4
cd(projectFolder);   % Will need to change this if running from other locations

% Set file path to gsflow batch file (must be full file path)
CM1 = ['cd ' projectFolder '\gsflow & .\gsflow_run.bat'];

% Set analysis preferences
buildParameterFile = 1; % If want to build parameter file
buildControlFile = 1;   % If want to build control file
runModel = 1;  % If want to run model
Analyze_calibResults = 1;   % If want to analyze model results after model run
Analyze_betterRun = 1;   % If want to compare model results to a specified comparison run

% MUST CHANGE THESE FOR EACH SET OF RUNS
% Set initial and final simulation indices
<<<<<<< HEAD
N0 = 1021; %Initial simulation
N = 1760; % Final simulation
=======
N0 = 21; %Initial simulation
N = 760; % Final simulation
>>>>>>> 94ef842b9f804b231bcbd21185ab0857ff7d93f4
N1 = 20; % Set how many simulations to run before summary file is generated - should be equal to the number of multipliers in a spreadsheet
multiplierFolder = 'random_multipliers'; % Either 'systematic_multipliers' or 'random_multipliers'

% Run function
prms_calibration_incremental_alameda_FUNCTION(buildParameterFile, buildControlFile, runModel, Analyze_calibResults, Analyze_betterRun, N0, N, N1, CM1, multiplierFolder)