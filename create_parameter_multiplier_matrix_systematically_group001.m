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
paramNames01 = {
    'carea_max'  
    'smidx_coef' 
    'smidx_exp'};

paramNames02 = {
    'pref_flow_den'
    'soil_moist_max'
    'soil2gw_max'
    'sat_threshold'
    'slowcoef_lin'
    'slowcoef_sq' 
    'fastcoef_lin'
    'fastcoef_sq'};

paramNames03 = {
    'gwflow_coef' % if make this larger get more baseflow - so probably want to do that
    'jh_coef'};  

paramNamesCell = {paramNames01; paramNames02; paramNames03};


% Create min parameter value vector
minVal01 = [
    0
    0.001
    0.1
    ];

minVal02 = [
    0
    0.001
    0
    1
    0.001
    0.001
    0.001
    0.001
    ];

minVal03 = [
    0.001
    0.005
    ];

minValCell = {minVal01; minVal02; minVal03};



% Create max parameter value vector
maxVal01 = [
    1
    0.06
    0.5
    ];

maxVal02 = [
    1
    10
    5
    999
    0.5
    1
    1
    1
    ];

maxVal03 = [
    0.5
    0.06
    ];

maxValCell = {maxVal01; maxVal02; maxVal03};


% Loop through each set of parameters
pCell = cell(numel(paramNamesCell), 1);
for i=1:numel(paramNamesCell)
    
    % Extract paramNames, minVal, and maxVal for this set of parameters
    paramNames = paramNamesCell{i};
    minVal = minValCell{i};
    maxVal = maxValCell{i};
    
    % Create multipliers vector
    multAll = [0.25, 2]; 
    
    % Create permuations (with replacement) of the multipliers vector
    p = permn(multAll,numel(paramNames)).';
    pCell{i} = p;
    
    % Change 0.25 to 0.9 and 2 to 1.1 for carea_max in order to only change
    % carea max by +/- 10%
    if i==1
        colIdx = find( p(1,:) == 0.25 );
        p(1, colIdx) = 0.9;
        
        colIdx = find( p(1,:) == 2 );
        p(1, colIdx) = 1.1;
    end
    
    
    % Assign starting run number
    if i == 1
        runNumPrev = 0;
    else
        runNumPrev = numel(pCell{i-1}(1,:));
    end
    
    % Package parameter name, min and max parameter values, and multiplier permutations all together in a table
    pNamesCell = num2cell((runNumPrev + 1):(runNumPrev + numel(p(1,:))));
    pNamesCellStr = cellfun(@num2str, pNamesCell, 'UniformOutput', false);
    pNamesCellStrM = cellfun(@(v) ['M' v], pNamesCellStr, 'Uniform', false);
    pT = array2table(p, 'VariableNames',  pNamesCellStrM);
    iT = table(paramNames,minVal,maxVal, 'VariableNames', {'parameter', 'min', 'max'});
    T = [iT pT];
    
    % Export to one excel file
    filename = sprintf('./calibration_data/systematic_multipliers/calibration_parameter_multipliers_0%d.xlsx',i);
    writetable(T, filename);
    
     
%     % Export to many excel files
%     numRunsPerParamFile = 100;
%     idxStart = 4:numRunsPerParamFile:numel(p(1,:));
%     idxStart = idxStart(1:(end-1));
%     idxEnd = 103:numRunsPerParamFile:numel(p(1,:));
%     idxEnd(end) = numel(p(1,:));
    
%     for j=1:numel(idxStart)
%         iS = idxStart(j);
%         iE = idxEnd(j);
%         Tpart = T(:, [1:3, (iS):iE]);
%         filename = sprintf('./calibration_data/systematic_multipliers/00%d/calibration_parameters_0%d.xlsx',i, j);
%         writetable(Tpart, filename);
%     end
    
    
end









