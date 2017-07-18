clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Load
experimentPath = 'Experiment_14_PlanarAngularInfo';

% trials = 1:20;
% trials = [1 2 5 6 9 10 13 14 17 18]; %low point noise | flat
% trials = [3 4 7 8 11 12 15 16 19 20]; %high point noise | flat
% trials = [21 22 25 26 29 30 33 34 37 38]; %low point noise  | not flat
% trials = [23 24 27 28 31 32 35 36 39 40]; %high point noise | not flat

% trials = [4 31];
% nTrials = numel(trials);

trials = [2,14,20,21,26,27,28,30,31,37,38,39,40,41,42,44,45,47,50,...
     51,55,57,59,65,67,69,72,75,79,80,101,106,112,116,117,118,119,120,122,...
     132,133,134,139,142,144,145,147,149,152,153,154,155,158,159];

 nTrials =  length(trials);

NC_errors  = zeros(6,nTrials);
P_errors   = zeros(6,nTrials);
PA_errors  = zeros(6,nTrials);
PANoC_errors  = zeros(6,nTrials);
PAPC_errors  = zeros(6,nTrials);
SP_errors  = zeros(6,nTrials);
SPA_errors = zeros(6,nTrials);
SPANoC_errors = zeros(6,nTrials);
SPASPC_errors = zeros(6,nTrials);

for i = 1:numel(trials)
    
    fprintf('\nTrial: %d\n',trials(i))
    
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end 
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(trials(i)));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path

    groundTruthCell  = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruth.graph'),'noConstraints');
    groundTruthCellS = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruthS.graph'));
    
    resultsCell    = graphFileToCell(config,strcat(trialFilePath,sep,'results.graph'));
    resultsCellP   = graphFileToCell(config,strcat(trialFilePath,sep,'resultsP.graph'));
    resultsCellPA  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPA.graph'));
    resultsCellPANoC  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPANoC.graph'));
    resultsCellPAPC  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPAPC.graph'));
    resultsCellSP  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSP.graph'));
    resultsCellSPA = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPA.graph'));
    resultsCellSPANoC = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPANoC.graph'));
    resultsCellSPASPC = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPASPC.graph'));
    
    %compute errors
    graphGT   = Graph(config,groundTruthCell);
    graphGTS  = Graph(config,groundTruthCellS);
    graphN    = Graph(config,resultsCell);
    graphNP   = Graph(config,resultsCellP);
    graphNPA  = Graph(config,resultsCellPA);
    graphNPANoC  = Graph(config,resultsCellPANoC);
    graphNPAPC  = Graph(config,resultsCellPAPC);
    graphNSP  = Graph(config,resultsCellSP);
    graphNSPA = Graph(config,resultsCellSPA);
    graphNSPANoC = Graph(config,resultsCellSPANoC);
    graphNSPASPC = Graph(config,resultsCellSPASPC);
    
    results    = errorAnalysis(config,graphGT,graphN);
    resultsP   = errorAnalysis(config,graphGT,graphNP);
    resultsPA  = errorAnalysis(config,graphGT,graphNPA);
    resultsPANoC  = errorAnalysis(config,graphGT,graphNPANoC);
    resultsPAPC  = errorAnalysis(config,graphGT,graphNPAPC);
    resultsSP  = errorAnalysis(config,graphGTS,graphNSP);
    resultsSPA = errorAnalysis(config,graphGTS,graphNSPA);
    resultsSPANoC = errorAnalysis(config,graphGTS,graphNSPANoC);
    resultsSPASPC = errorAnalysis(config,graphGTS,graphNSPASPC);
    
    
    NC_errors(:,i)  = getErrors(results);
    P_errors(:,i)   = getErrors(resultsP);
    PA_errors(:,i)  = getErrors(resultsPA);
    PANoC_errors(:,i)  = getErrors(resultsPANoC);
    PAPC_errors(:,i)  = getErrors(resultsPAPC);
    SP_errors(:,i)  = getErrors(resultsSP);
    SPA_errors(:,i) = getErrors(resultsSPA);
    SPANoC_errors(:,i) = getErrors(resultsSPANoC);
    SPASPC_errors(:,i) = getErrors(resultsSPASPC);

end

NC_means  = mean(NC_errors,2);
P_means   = mean(P_errors,2);
PA_means  = mean(PA_errors,2);
PANoC_means = mean(PANoC_errors,2);
PAPC_means = mean(PAPC_errors,2);
SP_means  = mean(SP_errors,2);
SPA_means = mean(SPA_errors,2);
SPANoC_means = mean(SPANoC_errors,2);
SPASPC_means = mean(SPASPC_errors,2);
NC_medians  = median(NC_errors,2);
P_medians   = median(P_errors,2);
PA_medians  = median(PA_errors,2);
PANoC_medians  = median(PANoC_errors,2);
PAPC_medians  = median(PAPC_errors,2);
SP_medians  = median(SP_errors,2);
SPA_medians = median(SPA_errors,2);
SPANoC_medians = median(SPANoC_errors,2);
SPASPC_medians = median(SPASPC_errors,2);