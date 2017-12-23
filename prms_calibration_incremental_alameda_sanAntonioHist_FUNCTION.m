function prms_calibration_incremental_alameda_FUNCTION(buildParameterFile, buildControlFile, runModel, Analyze_calibResults, Analyze_betterRun, N0, N, N1, CM1, multiplierFolder)

% Date last updated: 10/19/2017

% Goal:
% The goal of this function is to incrementally calibrate PRMS.  (Say
% more about how function works.)

% Function inputs:
% (list function inputs)

% Function outputs:
% (list function outputs)


%% Set up

% Start tracking time
tic

% Print message saying the script has started
startMessage = ['San Antonio watershed incremental PRMS calibration started at: ' datestr(now)];
disp(startMessage)

% Initialize other variables
sameParamRun = N1;  % Number of simulations to run with the same parameter file
V1 = sameParamRun;  % Counter to determine when to read in new parameter file
V3 =  1;  % Counter to keep track of columns in output file
nHRU = 541242;
nMonths = 12;
oneVal = 1;
OutputHeading = {
    'Simulation Number'; 'Total WY Deviation'; 'October Deviation'; 'November Deviation'; 'December Deviation'; 'January Deviation';
    'February Deviation'; 'March Deviation'; 'April Deviation'; 'May Deviation'; 'June Deviation'; 'July Deviation';
    'August Deviation'; 'September Deviation'; 'Daily Deviation (mean of WY totals)'; ' ';
    
    'WY RMSE'; 'October RMSE'; 'November RMSE'; 'December RMSE'; 'January RMSE'; 'February RMSE'; 'March RMSE'; 'April RMSE'; 'May RMSE'; 'June RMSE'; 'July RMSE'; 'August RMSE';
    'September RMSE'; 'Daily RMSE (mean over all WY)'; ' ';
    
    'WY NSE'; 'October Monthly NSE'; 'November Monthly NSE'; 'December Monthly NSE'; 'January Monthly NSE';
    'February Monthly NSE'; 'March Monthly NSE'; 'April Monthly NSE'; 'May Monthly NSE'; 'June Monthly NSE';
    'July Monthly NSE'; 'August Monthly NSE'; 'September Monthly NSE'; 'Daily NSE (for all WY together)'; 'October Daily NSE';
    'November Daily NSE'; 'December Daily NSE'; 'January Daily NSE';'February Daily NSE'; 'March Daily NSE';
    'April Daily NSE'; 'May Daily NSE'; 'June Daily NSE'; 'July Daily NSE'; 'August Daily NSE'; 'September Daily NSE'; ' ';
    
    'WY VE'; 'October Monthly VE'; 'November Monthly VE'; 'December Monthly VE'; 'January Monthly VE';
    'February Monthly VE'; 'March Monthly VE'; 'April Monthly VE'; 'May Monthly VE'; 'June Monthly VE';
    'July Monthly VE'; 'August Monthly VE'; 'September Monthly VE'; 'Daily VE (for all WY together)';
    'October Daily VE'; 'November Daily VE'; 'December Daily VE'; 'January Daily VE';'February Daily VE'; 'March Daily VE';
    'April Daily VE'; 'May Daily VE'; 'June Daily VE'; 'July Daily VE'; 'August Daily VE'; 'September Daily VE'; ' ';
    
    'Percent Bias Runoff Ratio';  'Percent Bias FDC Midsegment Slope'; 'Percent Bias FDC High-segment Volume';
    'Percent Bias FDC Low-segment Volume'; 'Percent Bias Time Lag';  'Percent Bias Median Log Flow'};

% Set simulation start and end dates
[yy1, mm1, dd1] = datevec('10/1/1912'); % Simulation start date
[yy2, mm2, dd2] = datevec('9/30/1930'); % Simulation end date


%% Read in data

% Upload calibration data
[calibFlows, ~] = xlsread('.\calibration_data\alameda_data_20170906_streamflows_SanAntCkHist.xlsx'); % Stream flow data
if Analyze_betterRun
    calibCompRun_SAC = xlsread('.\calibration_results\calibResults_randomRunsGroup001_run350_historic_SAC.xlsx', 'run350_SAC');
    calibCompRun = {calibCompRun_SAC};
end
idxNA = find(calibFlows == -999);
calibFlows(idxNA) = NaN;
calibDate = calibFlows(:, 1:3);
calibFlows = calibFlows(:,4:end);
flowForCalib = 4;  % Select streamflow columns for calibration - same ID #s as PRMS data file  
flowForCalibNames = ['San Antonio Creek'];  % Create vector of streamflow site names for calibration
calibFlows = calibFlows(:,flowForCalib);

% Upload input file format
Astr = fileread('.\gsflow\input\prms\alameda_calibration_parameters.param');  % Make sure this has all the calibration parameters in it, it currently doesn't.  Is this just the most recent parameter file or does it have a different format?

% Set up output file 
OutputMat = zeros(numel(OutputHeading),N1+1);
Output = {OutputMat};



%% Build parameter file, build control file, do simulations, and analyze results

for V0 = N0:N    % Run through N simulations
    %% Build parameter file
    
    % Advance V1
    V1 = V1+1;
    
    % Advance V3
    V3 = V3 + 1;
    
    % If building parameter file
    if buildParameterFile
        
        % Upload parameter values every sameParamRun+1 runs
        if V1 == (sameParamRun + 1)
            %cd('C:\gsflow_onlyPRMS');
            [ParameterValues, ParameterNames] = xlsread(['.\calibration_data\' multiplierFolder '\calibration_parameter_multipliers_0' num2str(floor((V0-1)/sameParamRun)+1) '.xlsx'], 'Sheet1');
            minParamVal = ParameterValues(:, 1);  % assumes that the first column of ParameterValues contains min parameter values
            maxParamVal = ParameterValues(:, 2);  % assumes that the second column of ParameterValues contains max parameter values
            ParameterNames = ParameterNames(2:end,1); % assumes that the first column of ParameterNames contains the parameter names (and that there's a column header)
            ParameterValues = ParameterValues(:,3:end);
            V1 = V0 - floor(V0/sameParamRun) * sameParamRun;
        end
        
        % Change parameter file
        A = regexp(Astr, '\n', 'split');  % Create temporary variable with text of PRMS input file
        for i = 1:numel(ParameterValues(:,1)) % Change parameter values - parameter names and values taken from uploaded file above
            
            % Find location of parameter in PRMS input file
            Aofs = min(strfind(Astr, cell2mat(ParameterNames(i))));  % Using min because x_coef is seen twice - the second is smidx_coef
            j = numel(regexp(Astr(1:Aofs), '\n')) + 1;
            Temp = char(A(j)); % This is the parameter
            Temp2 = char(A(j+2)); % This is 2 lines later, which is the dimension of the parameter (e.g. nhru, ntemp, etc...)
            
            
            % Identify dimension
            % So far only dealing with nhru or nmonths, but could add in other dimensions as needed
            if strcmp(Temp2(1:end-1), 'nhru') |  strcmp(Temp2(1:end-1), 'ngw') |  strcmp(Temp2(1:end-1), 'nssr') % These parameters have nhru values
                paramDim = nHRU;
                
            elseif strcmp(Temp2(1:end-1), 'nmonths')
                paramDim = nMonths;
                
            elseif strcmp(Temp2(1:end-1), 'one')
                paramDim = oneVal;
                
            else
                error('Parameter dimension is not equal to nhru, nmonths, or one.  Code currently only handles parameters with dimension = nhru or nmonths or one.');
                
            end
            
            
            % Replace parameter values
            % Turn parameters base values into double vector
            paramValVec = cellfun(@str2num, A( (j+5) : (j + 4 + paramDim))).';  % This is really slow - figure out how to do this more quickly, maybe using cell2mat
            
            % Multiply parameter base value by multiplication factor
            paramValMult = paramValVec .* ParameterValues(i, V1);
            
            % If new value is less than minParamVal, then set equal to minParamVal
            belowMin = find(paramValMult < minParamVal(i));
            if numel(belowMin) > 0
                paramValMult(belowMin) = minParamVal(i);
            end
            
            % If new value is greater than maxParamVal, then set equal to maxParamVal
            aboveMax = find(paramValMult > maxParamVal(i));
            if numel(aboveMax) > 0
                paramValMult(aboveMax) = maxParamVal(i);
            end
            
            % Place new parameter values in A
            A( (j+5) : (j + 4 + paramDim)) = cellstr(num2str(paramValMult));
            
            
        end
        
        
        % Write new param file
        fid = fopen('.\gsflow\input\prms\alameda_calibration_parameters_updated.param', 'w');  % Update this if change capitalization of folders
        if fid > 2 % why 2?  and why allow for the possibility of opening a file and not printing to it?
            fprintf(fid, '%s\n', A{:});
            fclose(fid);
        end
        
    end
    %% Build control file
    
    % If building control file
    if buildControlFile
        
        % Change control file (only first time around)
        %if Restart || V0 == 1
        %Restart = 0;
        clear A
        
        % Change capitalization and slash direction
        A = regexp(fileread('.\gsflow\alameda_prms.control'), '\n', 'split');
        for i = 1:numel(A)
            temp = cell2mat(A(i));
            a1 = temp(1:end-1);
            if strcmp(a1, 'ani_output_file')
                A{i+3} = sprintf('%s', ['./output/prms/animation.out' temp(end)]);      % change file path, what purpose does temp(end) serve?
            elseif strcmp(a1, 'statsON_OFF')
                A{i+3} = sprintf('%s', ['1' temp(end)]);
            elseif strcmp(a1, 'aniOutON_OFF')
                A{i+3} = sprintf('%s', ['0' temp(end)]);
            elseif strcmp(a1, 'param_file')
                A{i+3} = sprintf('%s', ['./input/prms/alameda_calibration_parameters_updated.param' temp(end)]); % what purpose does temp(end) serve?
                A{i+4} = sprintf('%s', ['./input/prms/alameda_cascade.param' temp(end)]);
                A{i+5} = sprintf('%s', ['./input/prms/alameda_default_values.param' temp(end)]);
                A{i+6} = sprintf('%s', ['./input/prms/alameda_gis_derived_parameters.param' temp(end)]);
            elseif strcmp(a1, 'model_output_file')
                runFolder = sprintf('%04d', V0);
                A{i+3} = ['.\output\prms\', runFolder, '\prms.out', temp(end)];      % what purpose does temp(end) serve?
            elseif strcmp(a1, 'stat_var_file')
                runFolder = sprintf('%04d', V0);
                A{i+3} = ['.\output\prms\', runFolder, '\statvar.dat', temp(end)];    % change file path
            elseif strcmp(a1, 'stats_output_file')
                A{i+3} = sprintf('%s', ['./output/prms/stats1.out' temp(end)]);    % change file path
            elseif strcmp(a1, 'start_time')
                A{i+3} = sprintf('%s', [num2str(yy1) temp(end)]);
                A{i+4} = sprintf('%s', [num2str(mm1) temp(end)]);
                A{i+5} = sprintf('%s', [num2str(dd1) temp(end)]);
            elseif strcmp(a1, 'end_time')
                A{i+3} = sprintf('%s', [num2str(yy2) temp(end)]);
                A{i+4} = sprintf('%s', [num2str(mm2) temp(end)]);
                A{i+5} = sprintf('%s', [num2str(dd2) temp(end)]);
            elseif strcmp(a1, 'nsubOutBaseFileName')
                runFolder = sprintf('%04d', V0);
                A{i+3} = ['.\output\prms\', runFolder, '\nsubOutVar\nsub.', temp(end)];
                
            end
        end
        
        fid = fopen('.\gsflow\alameda_prms_updated.control', 'w');
        if fid > 2 % why 2?  and why allow for the possibility of opening a file and not printing to it?
            fprintf(fid, '%s\n', A{:});
            fclose(fid);
        end
        %end
        
    end
    
    %% Run PRMS
    
    % If running model
    if runModel
        
        % Run model
        FN1 = '.\gsflow\input\prms\alameda_calibration_parameters_updated.param';
        FN2 = '.\gsflow\alameda_prms_updated.control';
        if exist(FN1, 'file') && exist(FN2, 'file')
            %cd('.\gsflow')
            %CM1 = '.\gsflow\gsflow_run.bat';
            status = dos(CM1);
            [num2str(V0 -N0 + 1) ' simulations done. Elapsed time is ' num2str(toc/3600) ' hours; Expected finish time is ' datestr(now+(N-V0)*toc/(V0 -N0 + 1)/24/60/60)] % Print out schedule
        end
        %cd('C:\gsflow_onlyPRMS');
        
    end
    
    %% Analyze results
    
    if Analyze_calibResults
        
        % Read in statvar file
        runFolder = sprintf('%04d', V0);
        FN = ['.\gsflow\output\prms\', runFolder, '\statvar.dat'];
        
        if exist(FN, 'file') % Make sure file exists
            b = dir(FN);
            
            if b.bytes > 5000 % Make sure file is big (not incomplete)
                Temp = importdata(FN, ' ', 255); % upload output file
                a = Temp.data;
                
                % Extract year, month, day, and San Antonio Creek streamflow and precip from statvar file
                statvarDate = a(:, [2,3,4]);
                statvarFlows = a(:, 11);  
                statvarPrecip = a(:,37); 
                
                % Place calibFlows and statvarFlows in one cell array
                flows = {calibFlows, statvarFlows};
                
                % Extract information from calibFlows (measured streamflow data) and statvarFlows to prep for comparison with results
                % The following code assumes that the values in calibFlows and statvarFlows have their dates lined up
                                
                % Create water year
                WY = a(:,2);
                Ind = find(a(:,3) >= 10);
                WY(Ind) = WY(Ind)+1;
                uniqueWY = unique(WY);
                
                % Extract month
                Month = a(:,3);
                uniqueMonth = [10:12, 1:9];
                
                % Initialize cell arrays
                matWYMS = {};
                meanMonthlyFlowMS = {};
                dailyFlowMS = {};
                dailyFlowAllWY ={};
                dailyFlowMonthly = {};
                
                
                for t=1:numel(flows)
                    
                    % Extract total water year volume in acre-ft and store in cell array
                    vol = (flows{t} .* 86400)./43559.9;   % Convert cfs to acre-ft/day.  86400 cfs per day.  43559.9 cubic ft per acre-ft.
                    matWY = [];
                    for i=1:numel(uniqueWY)
                        idx = find(WY == uniqueWY(i));
                        matWY(i,:) = [uniqueWY(i), nansum(vol(idx,:))];
                    end
                    matWYMS{t} = matWY;
                    
                    % Extract mean monthly flow in cfs (for each water year separately) and store in cell array
                    meanMonthlyFlow = {};
                    for i = 1:numel(uniqueWY)
                        
                        tmp = [];
                        for j = 1:numel(uniqueMonth)
                            idx = find(Month == uniqueMonth(j) & WY == uniqueWY(i));
                            tmp(j,:) = [uniqueMonth(j), nanmean(flows{t}(idx,:))];
                        end
                        meanMonthlyFlow{i} = tmp;
                        
                    end
                    meanMonthlyFlowMS{t} = meanMonthlyFlow;
                    
                    % Extract daily flow in cfs for each water year separately and store in cell array
                    dailyFlow ={};
                    for i = 1:numel(uniqueWY)
                        
                        idx = find(WY == uniqueWY(i));
                        dailyFlow{i} = [calibDate(idx,:), flows{t}(idx,:)];
                        
                    end
                    dailyFlowMS{t} = dailyFlow;
                    
                    
                    % Extract daily flow in cfs for each month separately (but all water years together)
                    % and store in cell array
                    dailyFlowMonthlyEach = {};
                    for i = 1:numel(uniqueMonth)
                        
                        idx = find(Month == uniqueMonth(i));
                        dailyFlowMonthlyEach{i} = [calibDate(idx,:), flows{t}(idx,:)];
                        
                    end
                    dailyFlowMonthly{t} = dailyFlowMonthlyEach;
                    
                    
                    % Extract daily flow in cfs for all water years together and store in cell array
                    dailyFlowAllWY{t} = [calibDate, flows{t}];
                    
                    
                end
                
                
                %end
                
                
                
                % Set simulation number
                for t=1:numel(Output)
                    
                    % Simulation number
                    Output{t}(1,V3) = V0;
                    
                    % Total water year mean absolute deviation (acre-ft)
                    Output{t}(2,V3) = nanmean(abs(matWYMS{1}(:,(t+1)) - matWYMS{2}(:,(t+1))));
                    
                    % Monthly mean absolute deviation (mean over all water years) (cfs)
                    tmp = zeros(numel(uniqueMonth), numel(uniqueWY));
                    for q=1:numel(meanMonthlyFlowMS{1})
                        tmp(:,q) = abs(meanMonthlyFlowMS{1}{q}(:,(t+1)) - meanMonthlyFlowMS{2}{q}(:,(t+1)));
                    end
                    Output{t}(3,V3) = nanmean(tmp(1,:));  % October mean absolute deviation
                    Output{t}(4,V3) = nanmean(tmp(2,:));  % November mean absolute deviation
                    Output{t}(5,V3) = nanmean(tmp(3,:));  % December mean absolute deviation
                    Output{t}(6,V3) = nanmean(tmp(4,:));  % January mean absolute deviation
                    Output{t}(7,V3) = nanmean(tmp(5,:));  % February mean absolute deviation
                    Output{t}(8,V3) = nanmean(tmp(6,:));  % March mean absolute deviation
                    Output{t}(9,V3) = nanmean(tmp(7,:));  % April mean absolute deviation
                    Output{t}(10,V3) = nanmean(tmp(8,:));  % May mean absolute deviation
                    Output{t}(11,V3) = nanmean(tmp(9,:));  % June mean absolute deviation
                    Output{t}(12,V3) = nanmean(tmp(10,:));  % July mean absolute deviation
                    Output{t}(13,V3) = nanmean(tmp(11,:));  % August mean absolute deviation
                    Output{t}(14,V3) = nanmean(tmp(12,:));  % Septmenber mean absolute deviation
                    
                    
                    % Daily absolute total deviation (mean of water year totals)
                    tmp = zeros(numel(uniqueWY), 1);
                    for q=1:numel(dailyFlowMS{1})
                        tmp(q) = nansum(abs(dailyFlowMS{1}{q}(:,(t+3)) - dailyFlowMS{2}{q}(:,(t+3))));
                    end
                    Output{t}(15,V3) = nanmean(tmp);
                    
                    
                    % ' '
                    % Leave Output{t}(16,V3) blank
                    Output{t}(16,V3) = NaN;  % set it to NaN for now
                    
                    
                    % Water year RMSE (mean over all water years)
                    n = numel(matWYMS{1}(:,(t+1)));
                    Output{t}(17,V3) = nanmean(sqrt(((matWYMS{1}(:,(t+1)) - matWYMS{2}(:,(t+1))).^2)./n));
                    
                    
                    % Monthly RMSE (mean over all water years)
                    tmp = zeros(numel(uniqueMonth), numel(uniqueWY));
                    for q=1:numel(meanMonthlyFlowMS{1})
                        tmp(:,q) = (meanMonthlyFlowMS{1}{q}(:,(t+1)) - meanMonthlyFlowMS{2}{q}(:,(t+1))).^2;
                    end
                    n = numel(tmp(1,:));
                    Output{t}(18,V3) = sqrt(nansum(tmp(1,:))./n);  % October RMSE
                    Output{t}(19,V3) = sqrt(nansum(tmp(2,:))./n);  % November RMSE
                    Output{t}(20,V3) = sqrt(nansum(tmp(3,:))./n);  % December RMSE
                    Output{t}(21,V3) = sqrt(nansum(tmp(4,:))./n);  % January RMSE
                    Output{t}(22,V3) = sqrt(nansum(tmp(5,:))./n); % February RMSE
                    Output{t}(23,V3) = sqrt(nansum(tmp(6,:))./n); % March RMSE
                    Output{t}(24,V3) = sqrt(nansum(tmp(7,:))./n);  % April RMSE
                    Output{t}(25,V3) = sqrt(nansum(tmp(8,:))./n);  % May RMSE
                    Output{t}(26,V3) = sqrt(nansum(tmp(9,:))./n);  % June RMSE
                    Output{t}(27,V3) = sqrt(nansum(tmp(10,:))./n);  % July RMSE
                    Output{t}(28,V3) = sqrt(nansum(tmp(11,:))./n);  % August RMSE
                    Output{t}(29,V3) = sqrt(nansum(tmp(12,:))./n);  % Septmenber RMSE
                    
                    
                    % Daily RMSE (mean over all WY)
                    tmp = zeros(numel(uniqueWY), 1);
                    n = numel(dailyFlowMS{1}{q}(:,(t+3)));
                    for q=1:numel(dailyFlowMS{1})
                        tmp(q) = sqrt(nansum(((dailyFlowMS{1}{q}(:,(t+3)) - dailyFlowMS{2}{q}(:,(t+3))).^2)./n));
                    end
                    Output{t}(30,V3) = nanmean(tmp);
                    
                    
                    % ' '
                    % Leave Output{t}(31,V3) blank
                    Output{t}(31,V3) = NaN;  % set it to NaN for now
                    
                    
                    
                    % WY NSE
                    numerator = nansum((matWYMS{2}(:,(t+1)) - matWYMS{1}(:,(t+1))).^2);
                    denominator = nansum((nanmean(matWYMS{1}(:,(t+1))) - matWYMS{1}(:,(t+1))).^2);
                    Output{t}(32,V3) = 1 - (numerator/denominator);
                    
                    
                    % Monthly NSE
                    tmpNumer = zeros(numel(uniqueMonth), numel(uniqueWY));
                    tmpDenom = zeros(numel(uniqueMonth), numel(uniqueWY));
                    for q=1:numel(meanMonthlyFlowMS{1})
                        tmpNumer(:,q) = (meanMonthlyFlowMS{2}{q}(:,(t+1)) - meanMonthlyFlowMS{1}{q}(:,(t+1))).^2;
                        tmpDenom(:,q) = meanMonthlyFlowMS{1}{q}(:,(t+1));
                    end
                    Output{t}(33,V3) =  1 - ( nansum(tmpNumer(1,:)) ./ nansum((nanmean(tmpDenom(1,:)) - tmpDenom(1,:)).^2));  % October NSE
                    Output{t}(34,V3) = 1 - ( nansum(tmpNumer(2,:)) ./ nansum((nanmean(tmpDenom(2,:)) - tmpDenom(2,:)).^2)); % November NSE
                    Output{t}(35,V3) = 1 - ( nansum(tmpNumer(3,:)) ./ nansum((nanmean(tmpDenom(3,:)) - tmpDenom(3,:)).^2));  % December NSE
                    Output{t}(36,V3) = 1 - ( nansum(tmpNumer(4,:)) ./ nansum((nanmean(tmpDenom(4,:)) - tmpDenom(4,:)).^2));  % January NSE
                    Output{t}(37,V3) = 1 - ( nansum(tmpNumer(5,:)) ./ nansum((nanmean(tmpDenom(5,:)) - tmpDenom(5,:)).^2)); % February NSE
                    Output{t}(38,V3) = 1 - ( nansum(tmpNumer(6,:)) ./ nansum((nanmean(tmpDenom(6,:)) - tmpDenom(6,:)).^2)); % March NSE
                    Output{t}(39,V3) = 1 - ( nansum(tmpNumer(7,:)) ./ nansum((nanmean(tmpDenom(7,:)) - tmpDenom(7,:)).^2)); % April NSE
                    Output{t}(40,V3) = 1 - ( nansum(tmpNumer(8,:)) ./ nansum((nanmean(tmpDenom(8,:)) - tmpDenom(8,:)).^2));  % May NSE
                    Output{t}(41,V3) = 1 - ( nansum(tmpNumer(9,:)) ./ nansum((nanmean(tmpDenom(9,:)) - tmpDenom(9,:)).^2));  % June NSE
                    Output{t}(42,V3) = 1 - ( nansum(tmpNumer(10,:)) ./ nansum((nanmean(tmpDenom(10,:)) - tmpDenom(10,:)).^2));  % July NSE
                    Output{t}(43,V3) = 1 - ( nansum(tmpNumer(11,:)) ./ nansum((nanmean(tmpDenom(11,:)) - tmpDenom(11,:)).^2)); % August NSE
                    Output{t}(44,V3) = 1 - ( nansum(tmpNumer(12,:)) ./ nansum((nanmean(tmpDenom(12,:)) - tmpDenom(12,:)).^2));  % Septmenber NSE
                    
                    
                    % Daily NSE (for all water years together)
                    numerator = nansum((dailyFlowAllWY{2}(:,t+3) - dailyFlowAllWY{1}(:,t+3)).^2);
                    denominator = nansum((nanmean(dailyFlowAllWY{1}(:,t+3)) - dailyFlowAllWY{1}(:,t+3)).^2);
                    Output{t}(45,V3) = 1 - (numerator./denominator);
                    
                    
                    % Daily NSE (for each month separately, but with all water years together)
                    for i=1:numel(dailyFlowMonthly{1})
                        numerator = nansum((dailyFlowMonthly{2}{i}(:,t+3) - dailyFlowMonthly{1}{i}(:,t+3)).^2);
                        denominator = nansum((nanmean(dailyFlowMonthly{1}{i}(:,t+3)) - dailyFlowMonthly{1}{i}(:,t+3)).^2);
                        Output{t}((45+i),V3) = 1 - (numerator./denominator);  % October to September
                    end
                    

                    
                    % ' '
                    % Leave Output{t}(31,V3) blank
                    Output{t}(58,V3) = NaN;  % set it to NaN for now
                    
                    
                    % WY VE
                    numerator = nansum(abs(matWYMS{2}(:,(t+1)) - matWYMS{1}(:,(t+1))));
                    denominator = nansum(matWYMS{1}(:,(t+1)));
                    Output{t}(59,V3) = 1 - (numerator/denominator);
                    
                    
                    % Monthly VE
                    tmpNumer = zeros(numel(uniqueMonth), numel(uniqueWY));
                    tmpDenom = zeros(numel(uniqueMonth), numel(uniqueWY));
                    for q=1:numel(meanMonthlyFlowMS{1})
                        tmpNumer(:,q) = abs(meanMonthlyFlowMS{2}{q}(:,(t+1)) - meanMonthlyFlowMS{1}{q}(:,(t+1)));
                        tmpDenom(:,q) = meanMonthlyFlowMS{1}{q}(:,(t+1));
                    end
                    Output{t}(60,V3) =  1 - ( nansum(tmpNumer(1,:)) ./ nansum(tmpDenom(1,:)));  % October VE
                    Output{t}(61,V3) = 1 - ( nansum(tmpNumer(2,:)) ./ nansum(tmpDenom(2,:))); % November VE
                    Output{t}(62,V3) = 1 - ( nansum(tmpNumer(3,:)) ./ nansum(tmpDenom(3,:)));  % December VE
                    Output{t}(63,V3) = 1 - ( nansum(tmpNumer(4,:)) ./ nansum(tmpDenom(4,:)));  % January VE
                    Output{t}(64,V3) = 1 - ( nansum(tmpNumer(5,:)) ./ nansum(tmpDenom(5,:))); % February VE
                    Output{t}(65,V3) = 1 - ( nansum(tmpNumer(6,:)) ./ nansum(tmpDenom(6,:))); % March VE
                    Output{t}(66,V3) = 1 - ( nansum(tmpNumer(7,:)) ./ nansum(tmpDenom(7,:))); % April VE
                    Output{t}(67,V3) = 1 - ( nansum(tmpNumer(8,:)) ./ nansum(tmpDenom(8,:)));  % May VE
                    Output{t}(68,V3) = 1 - ( nansum(tmpNumer(9,:)) ./ nansum(tmpDenom(9,:)));  % June VE
                    Output{t}(69,V3) = 1 - ( nansum(tmpNumer(10,:)) ./ nansum(tmpDenom(10,:)));  % July VE
                    Output{t}(70,V3) = 1 - ( nansum(tmpNumer(11,:)) ./ nansum(tmpDenom(11,:))); % August VE
                    Output{t}(71,V3) = 1 - ( nansum(tmpNumer(12,:)) ./ nansum(tmpDenom(12,:)));  % Septmenber VE
                    
                    
                    % Daily VE (for all water years together)
                    numerator = nansum(abs(dailyFlowAllWY{2}(:,t+3) - dailyFlowAllWY{1}(:,t+3)));
                    denominator = nansum(dailyFlowAllWY{1}(:,t+3));
                    Output{t}(72,V3) = 1 - (numerator./denominator);
                    
                    
                    % Daily VE (for each month separately, but with all water years together)
                    for i=1:numel(dailyFlowMonthly{1})
                        numerator = nansum(abs(dailyFlowMonthly{2}{i}(:,t+3) - dailyFlowMonthly{1}{i}(:,t+3)));
                        denominator = nansum(dailyFlowMonthly{1}{i}(:,t+3));
                        Output{t}((72+i),V3) = 1 - (numerator./denominator);  % October to September
                    end
                    
                    
                    % ' '
                    % Leave Output{t}(85,V3) blank
                    Output{t}(85,V3) = NaN;  % set it to NaN for now
                    
                    
                    % NOTE: need to adjust for multiple columns in all alameda version of this code
                    
                    
                    % 'Percent Bias Runoff Ratio';  
                    numerator = sum(matWYMS{2}(:,(t+1)) - matWYMS{1}(:,(t+1)));
                    denominator = sum(matWYMS{1}(:,t+1));
                    Output{t}(86,V3) = (numerator/denominator) * 100;
                    
                    
                    
                    
                    % prep for: 
                    % 'Percent Bias FDC Midsegment Slope',
                    % 'Percent Bias FDC High-segment Volume', and 
                    % 'Percent Bias FDC Low-segment Volume'; 
                    
                    
                    % sort flow from largest to smallest values
                    flowsSort = cell(size(flows));
                    idxSort = cell(size(flows));
                    for i = 1:numel(flows)
                        [flowsSort{i} idxSort{i}] = sort(flows{i}, 'descend');
                    end
                    
                    % calculate rank
                    sortRank = 1:numel(flowsSort{i});
                    
                    % calculate exceedence probability
                    excProb = flowsSort;
                    for i = 1:numel(flowsSort)
                        for m=1:numel(flowsSort{i})
                            
                            excProb{i}(m) = 100 * (sortRank(m) / (numel(flowsSort{i}) + 1));
                            
                        end
                    end
                    

                    % 'Percent Bias FDC Midsegment Slope'; 
                    m1=20;
                    m2=70;
                    QSm1 = interp1(excProb{2}, flowsSort{2}, m1);
                    QSm2 = interp1(excProb{2}, flowsSort{2}, m2);
                    QOm1 = interp1(excProb{1}, flowsSort{1}, m1);
                    QOm2 = interp1(excProb{1}, flowsSort{1}, m2);
                    tinyNumber = 0.001;
                    numerator = (log10(QSm1 + tinyNumber) - log10(QSm2 + tinyNumber)) - (log10(QOm1 + tinyNumber) - log10(QOm2 +tinyNumber));
                    denominator = (log10(QOm1 + tinyNumber) - log10(QOm2 + tinyNumber));
                    Output{t}(87,V3) = (numerator / denominator) * 100;
                                        
                    
                    
                    % 'Percent Bias FDC High-segment Volume';
                    % note: don't need to actually convert to volume since
                    % that'll just get canceled out in the calculation - so
                    % can just use flows
                    idxCell = cell(size(flowsSort));
                    for i=1:numel(excProb)
                        idxCell{i} = find(excProb{i} < 20);
                    end
                    numerator = sum(flowsSort{2}(idxCell{2}) - flowsSort{1}(idxCell{1}));
                    denominator = sum(flowsSort{1}(idxCell{1}));
                    Output{t}(88,V3) = (numerator / denominator) * 100;
                    
                    
                    

                    % 'Percent Bias FDC Low-segment Volume'; 
                    % note: don't need to actually convert to volume since
                    % that'll just get canceled out in the calculation - so
                    % can just use flows
                    % TO DO: think about whether you've treated the
                    % denominator correctly
                    QSmin = min(flowsSort{2});
                    QOmin = min(flowsSort{1});
                    idxCell = cell(size(flowsSort));
                    for i=1:numel(excProb)
                        idxCell{i} = find(excProb{i} > 70);
                    end
                    tinyNumber = 0.001;
                    numerator1 = sum(log10(flowsSort{2}(idxCell{2}) + tinyNumber) - log10(QSmin + tinyNumber));
                    numerator2 = sum(log10(flowsSort{1}(idxCell{1}) + tinyNumber) - log10(QOmin + tinyNumber));
                    numerator = numerator1 - numerator2;
                    denominator = numerator2 + tinyNumber;
                    Output{t}(89,V3) = -1 * (numerator / denominator) * 100;  % why is this multiplied by -1?  makes it more confusing to interpret.
                    


                   % prep for percent bias time lag
                   
                   % unsort exceedence probability to match flows and
                   % statvarPrecip
                   excProbUnsortIdx = 1:numel(excProb{1});
                   idxOrigObs(idxSort{1}) = excProbUnsortIdx;
                   idxOrigSim(idxSort{2}) = excProbUnsortIdx;
                   excProbUnsort = cell(size(excProb));
                   excProbUnsort{1} = excProb{1}(idxOrigObs);
                   excProbUnsort{2} = excProb{2}(idxOrigSim);
                   
 
                   %TO DO: figure out how to only use cross correlations
                   %from values with exceedence probability < 20%
                   % identify indices of flows with exceedence probability
                   % > 20% in flowsSort and set those flows equal to NaN
                   flowsCut = flows;
                   for i=1:numel(excProbUnsort)
                       idxCell{i} = find(excProbUnsort{i} > 20);
                       flowsCut{i}(idxCell{i}) = NaN;
                   end
                   

                   % calculate cross-correlation
                   isOkObs = isfinite(flowsCut{1});
                   isOkSim = isfinite(flowsCut{2});
                   [lagObs, ckObs, rObs, tdObs] = xcorrTD(statvarPrecip(isOkObs), flowsCut{1}(isOkObs));
                   [lagSim, ckSim, rSim, tdSim] = xcorrTD(statvarPrecip(isOkSim), flowsCut{2}(isOkSim));

                    
                   
                   % 'Percent Bias Time Lag'
                    Output{t}(90,V3) = ( (tdSim - tdObs) / tdObs) * 100;
                    
                    

                    % 'Percent Bias Median Log Flow'
                    numer = log10(median(flowsSort{2})) - log10(median(flowsSort{1}));
                    denom = log10(median(flowsSort{1}));
                    Output{t}(91,V3) = (numer / denom) * 100;
                    

                end
                
            end
        end
    end
    
    
    % Print out summary data every N1th simulations
    site = {'SAC'};
    padV0 = sprintf('%04d', V0);
    if V0/N1 == round(V0/N1)
        
        for t = 1:numel(Output)
            
            % Export calibration results
            if Analyze_calibResults
                xlswrite(['.\calibration_results\calibResults_' num2str(padV0) '_' site{t} '.xlsx'], Output{t}, 'Summary', 'A1');
                xlswrite(['.\calibration_results\calibResults_' num2str(padV0) '_' site{t} '.xlsx'], OutputHeading, 'Summary', 'A1');
            end
            
            
            % Analyze better run
            if Analyze_betterRun
                
                % Set filename for export of calibration comparisons
                filename = ['.\calibration_results\betterRuns_' num2str(padV0) '_' site{t}, '.xlsx'];
                
                
                % Compare runs to calibCompRun (comparison run)
                df = zeros(size(Output{t}));
                runComp = {df};
                for r = 2:size(Output{t}, 1)
                    
                    if r >= 2 && r <= 15
                        idxBetter = find(Output{t}(r,(2:end)) < calibCompRun{t}(r,1));
                        runComp{t}(r, idxBetter+1) = 1;
                    end
                    
                    if r >= 17 && r <= 30
                        idxBetter = find(Output{t}(r,(2:end)) < calibCompRun{t}(r,1));
                        runComp{t}(r, idxBetter+1) = 1;
                    end
                    
                    if r >= 32 && r <= 57
                        idxBetter = find(Output{t}(r,(2:end)) > calibCompRun{t}(r,1));
                        runComp{t}(r, idxBetter+1) = 1;
                    end
                    
                    if r >= 59 && r <= 84
                        idxBetter = find(Output{t}(r,(2:end)) > calibCompRun{t}(r,1));
                        runComp{t}(r, idxBetter+1) = 1;
                    end
                    
                    if r >= 86 && r <= 91
                        idxBetter = find(abs(Output{t}(r,(2:end))) < abs(calibCompRun{t}(r,1)));
                        runComp{t}(r, idxBetter+1) = 1;
                    end
                    
                end
                
                
                % Calculate how many metrics are better than calibCompRun for each run
                totalNumBetter = sum(runComp{t}(:,(2:end)))';
                totalNumBetterSim = Output{t}(1,(2:end))';
                totalNumBetterMat = [totalNumBetterSim, totalNumBetter];
                totalNumBetterHeader = {'SimulationNumber', 'totalNumBetter'};
                totalNumBetterHeaderPlace = [zeros(1, size(totalNumBetterMat,2)); totalNumBetterMat];
                
                
                % Find runs better than calibCompRun for all WY metrics
                betterWY_idx = find(runComp{t}(2,(2:end)) == 1 & runComp{t}(17,(2:end)) == 1 & ...
                    runComp{t}(32,(2:end)) == 1 & runComp{t}(59,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterWY_runs = tmp(1, betterWY_idx)';
                betterWY_runsHeaderPlace = [0; betterWY_runs];
                betterWY_runsHeader = {'SimulationNumber'};
                
                
                % Find runs better than calibCompRun for each monthly metric (October = 1)
                for m=1:12
                    idx = find( ...
                        runComp{t}(2+m,:) == 1 &...
                        runComp{t}(17+m,:) == 1 &...
                        runComp{t}(32+m,:) == 1 &...
                        runComp{t}(59+m,:) == 1);
                    tmp = Output{t}(:,(2:end));
                    betterMonthlyRuns{m,1} = tmp(1,idx-1);
                end
                betterMonthlyRuns = padcat(betterMonthlyRuns{:})';
                betterMonthlyRunsHeader = {'October', 'November', 'December', 'January',...
                    'February', 'March', 'April', 'May', 'June', 'July',...
                    'August', 'September'};
                betterMonthlyRunsHeaderPlace = [zeros(1,size(betterMonthlyRuns,2)); betterMonthlyRuns];
                
                
                % Find runs better than calibCompRun for each daily metric
                
                % Daily over entire WY
                idx = find( ...
                    runComp{t}(15,:) == 1 &...
                    runComp{t}(30,:) == 1 &...
                    runComp{t}(45,:) == 1 &...
                    runComp{t}(72,:) == 1);
                tmp = Output{t}(:,(2:end));
                betterDailyOverWYRuns = tmp(1,idx-1)';
                betterDailyOverWYRunsHeader = {'SimulationNumber'};
                betterDailyOverWYRunsHeaderPlace = [0; betterDailyOverWYRuns];
                
                
                
                % Daily for each month (October = 1)
                for d = 1:12
                    idx = find( ...
                        runComp{t}(45+d,:) == 1 &...
                        runComp{t}(72+d,:) == 1);
                    tmp = Output{t}(:,(2:end));
                    betterDailyPerMonthRuns{d} = tmp(1,idx-1);
                end
                betterDailyPerMonthRuns = padcat(betterDailyPerMonthRuns{:})';
                betterDailyPerMonthRunsHeader = {'October', 'November', 'December', 'January',...
                    'February', 'March', 'April', 'May', 'June', 'July',...
                    'August', 'September'};
                betterDailyPerMonthRunsHeaderPlace = [zeros(1,size(betterDailyPerMonthRuns,2)); betterDailyPerMonthRuns];
                
                
                % Find runs better than calibCompRun for 'Percent Bias Runoff Ratio'
                betterPercentBiasRunoffRatio_idx = find(runComp{t}(86,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasRunoffRatio_runs = tmp(1, betterPercentBiasRunoffRatio_idx)';
                betterPercentBiasRunoffRatio_runsHeaderPlace = [0; betterPercentBiasRunoffRatio_runs];
                betterPercentBiasRunoffRatio_runsHeader = {'SimulationNumber'};
                
                %  Find runs better than calibCompRun for 'Percent Bias FDC Midsegment Slope'
                betterPercentBiasFDCmidsegmentSlope_idx = find(runComp{t}(87,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasFDCmidsegmentSlope_runs = tmp(1, betterPercentBiasFDCmidsegmentSlope_idx)';
                betterPercentBiasFDCmidsegmentSlope_runsHeaderPlace = [0; betterPercentBiasFDCmidsegmentSlope_runs];
                betterPercentBiasFDCmidsegmentSlope_runsHeader = {'SimulationNumber'};
                
                
                % Find runs better than calibCompRun for 'Percent Bias FDC High-segment Volume';
                betterPercentBiasFDChighSegmentVol_idx = find(runComp{t}(88,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasFDChighSegmentVol_runs = tmp(1, betterPercentBiasFDChighSegmentVol_idx)';
                betterPercentBiasFDChighSegmentVol_runsHeaderPlace = [0; betterPercentBiasFDChighSegmentVol_runs];
                betterPercentBiasFDChighSegmentVol_runsHeader = {'SimulationNumber'};
                
                
                % Find runs better than calibCompRun for 'Percent Bias FDC Low-segment Volume';
                betterPercentBiasFDClowSegmentVol_idx = find(runComp{t}(89,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasFDClowSegmentVol_runs = tmp(1, betterPercentBiasFDClowSegmentVol_idx)';
                betterPercentBiasFDClowSegmentVol_runsHeaderPlace = [0; betterPercentBiasFDClowSegmentVol_runs];
                betterPercentBiasFDClowSegmentVol_runsHeader = {'SimulationNumber'};
                
                
                % Find runs better than calibCompRun for 'Percent Bias Time Lag';
                betterPercentBiasTimeLag_idx = find(runComp{t}(90,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasTimeLag_runs = tmp(1, betterPercentBiasTimeLag_idx)';
                betterPercentBiasTimeLag_runsHeaderPlace = [0; betterPercentBiasTimeLag_runs];
                betterPercentBiasTimeLag_runsHeader = {'SimulationNumber'};                
                
                
                % Find runs better than calibCompRun for 'Percent Bias Median Log Flow'
                betterPercentBiasMedianLogFlow_idx = find(runComp{t}(91,(2:end)) == 1);
                tmp = Output{t}(:,(2:end));
                betterPercentBiasMedianLogFlow_runs = tmp(1, betterPercentBiasMedianLogFlow_idx)';
                betterPercentBiasMedianLogFlow_runsHeaderPlace = [0; betterPercentBiasMedianLogFlow_runs];
                betterPercentBiasMedianLogFlow_runsHeader = {'SimulationNumber'};  
                                
                
                % Export
                if isempty(totalNumBetterHeaderPlace) == 0
                    xlswrite(filename, totalNumBetterHeaderPlace, 'totalNumBetter');
                end
                xlswrite(filename, totalNumBetterHeader, 'totalNumBetter');
                
                if isempty(betterWY_runsHeaderPlace) == 0
                    xlswrite(filename, betterWY_runsHeaderPlace, 'betterWY_runs');
                end
                xlswrite(filename, betterWY_runsHeader, 'betterWY_runs');
                
                if isempty(betterMonthlyRunsHeaderPlace) == 0
                    xlswrite(filename, betterMonthlyRunsHeaderPlace, 'betterMonthlyRuns');
                end
                xlswrite(filename, betterMonthlyRunsHeader, 'betterMonthlyRuns');
                
                if isempty(betterDailyOverWYRunsHeaderPlace) == 0
                    xlswrite(filename, betterDailyOverWYRunsHeaderPlace, 'betterDailyOverWYRuns');
                end
                xlswrite(filename, betterDailyOverWYRunsHeader, 'betterDailyOverWYRuns');
                
                if isempty(betterDailyPerMonthRunsHeaderPlace) == 0
                    xlswrite(filename, betterDailyPerMonthRunsHeaderPlace, 'betterDailyPerMonthRuns');
                end
                xlswrite(filename, betterDailyPerMonthRunsHeader, 'betterDailyPerMonthRuns');
                
                if isempty(betterPercentBiasRunoffRatio_runsHeaderPlace) == 0
                    xlswrite(filename, betterPercentBiasRunoffRatio_runsHeaderPlace, 'betterRunoffRatio');
                end
                xlswrite(filename, betterPercentBiasRunoffRatio_runsHeader, 'betterRunoffRatio');                
                
                if isempty(betterPercentBiasFDCmidsegmentSlope_runsHeaderPlace) == 0
                    xlswrite(filename, betterPercentBiasFDCmidsegmentSlope_runsHeaderPlace, 'betterFDCmidsegmentSlope');
                end
                xlswrite(filename, betterPercentBiasFDCmidsegmentSlope_runsHeader, 'betterFDCmidsegmentSlope');
                
                
                if isempty(betterPercentBiasFDChighSegmentVol_runsHeaderPlace) == 0
                    xlswrite(filename, betterPercentBiasFDChighSegmentVol_runsHeaderPlace, 'betterFDChighSegmentVol');
                end
                xlswrite(filename, betterPercentBiasFDChighSegmentVol_runsHeader, 'betterFDChighSegmentVol');
                
                
                if isempty(betterPercentBiasFDClowSegmentVol_runsHeaderPlace) == 0
                    xlswrite(filename, betterPercentBiasFDClowSegmentVol_runsHeaderPlace, 'betterFDClowSegmentVol');
                end
                xlswrite(filename, betterPercentBiasFDClowSegmentVol_runsHeader, 'betterFDClowSegmentVol');
                
                
                if isempty(betterPercentBiasMedianLogFlow_runsHeaderPlace) == 0
                    xlswrite(filename, betterPercentBiasMedianLogFlow_runsHeaderPlace, 'betterMedianLogFlow');
                end
                xlswrite(filename, betterPercentBiasMedianLogFlow_runsHeader, 'betterMedianLogFlow');
                
                
                % clear
                clear totalNumBetter
                clear betterWY_runs
                clear betterMonthlyRuns
                clear betterDailyOverWYRuns
                clear betterDailyPerMonthRuns
                clear betterPercentBiasRunoffRatio
                clear betterPercentBiasFDCmidsegmentSlope
                clear betterPercentBiasFDChighSegmentVol
                clear betterPercentBiasFDClowSegmentVol
                clear betterPercentBiasMedianLogFlow
                
                
                
                
            end
            
            
            % Zero out output matrix
            %[numRow, numCol] = size(Output{t});
            %Output{t} = [zeros(numRow, 1), Output{t}];
            Output{t} = Output{t}.*0;
        
        end
        
        % Reset V3
        V3 = 1;
        
    end
    
end

% Stop keeping time
toc

end


