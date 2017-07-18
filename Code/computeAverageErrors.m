clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Load
% experimentPath = 'Experiment_14_FullComparison_SUBMITTED';
experimentPath = 'Experiment_14_FullComparison_Starting_PlanarInfo';
% trials = 1:20;
% trials = [1 2 5 6 9 10 13 14 17 18]; %low point noise | flat
% trials = [3 4 7 8 11 12 15 16 19 20]; %high point noise | flat
% trials = [21 22 25 26 29 30 33 34 37 38]; %low point noise  | not flat
% trials = [23 24 27 28 31 32 35 36 39 40]; %high point noise | not flat

% trials = [4 31];
% nTrials = numel(trials);

nTrials = 160;
trials = 1:nTrials;

NC_errors  = zeros(6,nTrials);
P_errors   = zeros(6,nTrials);
PA_errors  = zeros(6,nTrials);
SP_errors  = zeros(6,nTrials);
SPA_errors = zeros(6,nTrials);

%% To compute average errors excluding cases that break angular constraints
%  breakingCases = [2,14,20,21,26,27,28,30,31,37,38,39,40,41,42,44,45,47,50,...
%      51,55,57,59,65,67,69,72,75,79,80,101,106,112,116,117,118,119,120,122,...
%      132,133,134,139,142,144,145,147,149,152,153,154,155,158,159];
breakingCases = [];

for i = 1:numel(trials)
    

    if(~isempty(find(breakingCases==i,1)))
        continue
    else
        
    fprintf('\nTrial: %d\n',i)
    
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end 
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(trials(i)));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path

    groundTruthCell  = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruth.graph'),'noConstraints');
    groundTruthCellS = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruthS.graph'));
    resultsCell    = graphFileToCell(config,strcat(trialFilePath,sep,'results.graph'));
    resultsCellP   = graphFileToCell(config,strcat(trialFilePath,sep,'resultsP.graph'));
    resultsCellPA  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPA.graph'));
    resultsCellSP  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSP.graph'));
    resultsCellSPA = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPA.graph'));
    
    %compute errors
    graphGT   = Graph(config,groundTruthCell);
    graphGTS  = Graph(config,groundTruthCellS);
    graphN    = Graph(config,resultsCell);
    graphNP   = Graph(config,resultsCellP);
    graphNPA  = Graph(config,resultsCellPA);
    graphNSP  = Graph(config,resultsCellSP);
    graphNSPA = Graph(config,resultsCellSPA);
    results    = errorAnalysis(config,graphGT,graphN);
    resultsP   = errorAnalysis(config,graphGT,graphNP);
    resultsPA  = errorAnalysis(config,graphGT,graphNPA);
    resultsSP  = errorAnalysis(config,graphGTS,graphNSP);
    resultsSPA = errorAnalysis(config,graphGTS,graphNSPA);
    
    NC_errors(:,i)  = getErrors(results);
    P_errors(:,i)   = getErrors(resultsP);
    PA_errors(:,i)  = getErrors(resultsPA);
    SP_errors(:,i)  = getErrors(resultsSP);
    SPA_errors(:,i) = getErrors(resultsSPA);
    end
 end

NC_errors(:,~any(NC_errors,1)) = [];
P_errors(:,~any(P_errors,1)) = [];
PA_errors(:,~any(PA_errors,1)) = [];
SP_errors(:,~any(SP_errors,1)) = [];
SPA_errors(:,~any(SPA_errors,1)) = [];

NC_means  = mean(NC_errors,2);
P_means   = mean(P_errors,2);
PA_means  = mean(PA_errors,2);
SP_means  = mean(SP_errors,2);
SPA_means = mean(SPA_errors,2);
NC_medians  = median(NC_errors,2);
P_medians   = median(P_errors,2);
PA_medians  = median(PA_errors,2);
SP_medians  = median(SP_errors,2);
SPA_medians = median(SPA_errors,2);