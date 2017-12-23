<<<<<<< HEAD
% Date last updated: 10/19/2017
=======
% Date last updated: 10/25/2017
>>>>>>> 2fd614c5b1d39a029a5b20037614310ee98a27ba

% Goal: 
% The goal of this script is to create a file in which the columns contain:
% 1: parameter name
% 2: min parameter value
% 3: max parameter value
% 4 - N: parameter multipliers for each parameter to be used in each run (1 column per run)

% Function inputs: 
% none

% Function outputs:
% parameter multiplier file to be used as input to
% prms_calibration_incremental_alameda_FUNCTION.m

%% Set up

% Clear/close out everything
clear 
close all
clc

% Create parameter name vector
paramNames = {
    'fastcoef_sq' 
    'pref_flow_den' 
    'slowcoef_sq' 
    'soil_moist_max' 
    'soil2gw_max' 
    'fastcoef_lin' 
    'gwflow_coef' 
    'jh_coef' 
    'slowcoef_lin'
    'sat_threshold'
    'carea_max'
    'smidx_coef'
    'smidx_exp'};


% Create min parameter value vector
minVal = [
    0.001
    0
    0.001
    0.001
    0
    0.001
    0.001
    0.005
    0.001
    1.0
    0
    0.001
    0.1];


% Create max parameter value vector
maxVal = [
    1
    1
    1
    10
    5
    1
    0.5
    0.06
    0.5
    999.0
    1
    0.06
    0.5];


% Create vector of all possible multipliers
multAll = [ 0.1, 0.25, 0.5, 0.75, 1, 1.5, 2., 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10];


% Sample from vector of all possible multipliers and store in a matrix
allRuns = 3000;
p = zeros( numel(paramNames), allRuns );
for i=1:allRuns
    p(:,i) = datasample(multAll, numel(paramNames));
end

% Adjust values of carea_max to fall between 0.75 and 1.25
rowIdx = 11; % row index of carea_max
careaMaxVal = [0.75, 0.775, 0.8, 0.825, 0.85, 0.875, 0.9, 0.925, 0.95, 1, 1.05, 1.1, 1.125, 1.15, 1.175, 1.2, 1.225, 1.25];

for i=1:length(careaMaxVal)
    colIdx = find( p(rowIdx,:) == multAll(i) );
    p(rowIdx, colIdx) = careaMaxVal(i);
end

% Package parameter name, min and max parameter values, and multiplier permutations all together in a table
pNamesCell = num2cell(1:numel(p(1,:)));  % change this to num2str (padding with white space) and then strsplit
pNamesCellStr = cellfun(@num2str, pNamesCell, 'UniformOutput', false);
pNamesCellStrM = cellfun(@(v) ['M' v], pNamesCellStr, 'Uniform', false);
pT = array2table(p, 'VariableNames',  pNamesCellStrM);
iT = table(paramNames,minVal,maxVal, 'VariableNames', {'parameter', 'min', 'max'});
T = [iT pT];

% Export to many excel files
numRunsPerParamFile = 20;
numNonMultCol = 3;
numMultCol = numel(p(1,:));
idxStart = (numNonMultCol + 1):numRunsPerParamFile:(numNonMultCol + numMultCol);
idxEnd = (numNonMultCol + numRunsPerParamFile):numRunsPerParamFile:(numNonMultCol + numMultCol);

for i=1:numel(idxStart)
    iS = idxStart(i);
    iE = idxEnd(i);
    Tpart = T(:, [1:3, (iS):iE]);
    filename = sprintf('./calibration_data/random_multipliers/calibration_parameter_multipliers_0%d.xlsx',i);
    writetable(Tpart, filename);
end





