% Date last updated: 6/19/2017

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
% prms_calibration_incremental_alameda_01.m

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

% paramNames = {
%     'fastcoef_sq'
%     'pref_flow_den'
%     'slowcoef_sq'
%     'soil_moist_max'
%     'soil2gw_max'};


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

% minVal = [
%     0.001
%     0
%     0.001
%     0.001
%     0];

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

% maxVal = [
%     1
%     1
%     1
%     10
%     5];

% Create vector of all possible multipliers
multAll = [0.25, 0.5, 1, 1.5, 2];

% Sample from vector of all possible multipliers and store in a matrix
allRuns = 1000;
p = zeros( numel(paramNames), allRuns );
for i=1:allRuns
    p(:,i) = datasample(multAll, numel(paramNames));
end

% Adjust values of carea_max to fall between 0.9 and 1.1
rowIdx = 11; % row index of carea_max
colIdx = find( p(rowIdx,:) == 0.25 );
p(rowIdx, colIdx) = 0.9;

colIdx = find( p(rowIdx,:) == 0.5 );
p(rowIdx, colIdx) = 0.95;

colIdx = find( p(rowIdx,:) == 1.5 );
p(rowIdx, colIdx) = 1.05;

colIdx = find( p(rowIdx,:) == 2 );
p(rowIdx, colIdx) = 1.1;

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





