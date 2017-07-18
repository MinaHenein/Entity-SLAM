clear all
clear classes
% close all
addpath(genpath(pwd))

experimentPath = 'Experiment_14_FullComparison_Starting_PlanarInfo';

nTrials = 160;
trials = 1:nTrials;
for i = trials
    
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(trials(i)));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path  
    
    %% 5. Load graph files
    groundTruthFileName   = strcat(trialFilePath,sep,'groundTruth.graph');
    groundTruthSFileName  = strcat(trialFilePath,sep,'groundTruthS.graph');
    measurementsFileName  = strcat(trialFilePath,sep,'measurements.graph');
    measurementsSFileName = strcat(trialFilePath,sep,'measurementsS.graph'); 
    resultsPAFileName  = strcat(trialFilePath,sep,'resultsPA.graph');
    resultsSPAFileName = strcat(trialFilePath,sep,'resultsSPA.graph');
    
    groundTruthCellPA   = graphFileToCell(config,groundTruthFileName);
    measurementsCellPA  = graphFileToCell(config,measurementsFileName);
    groundTruthCellSPA  = graphFileToCell(config,groundTruthSFileName);
    measurementsCellSPA = graphFileToCell(config,measurementsSFileName);

    %% 6. Solve
    %planar & angle constraints
    timeStartPA = tic;
    graph0PA    = Graph();
    initialSolP = strcat(trialFilePath,sep,'resultsP.graph');
    solverPA = graph0PA.processBatchDiffInitSol(config,measurementsCellPA,groundTruthCellPA,initialSolP);
    totalTimePA = toc(timeStartPA);
    fprintf('\nPlanar & angle constraints - total time solving: %f\n',totalTimePA)
    solverEndPA = solverPA(end);
    graph0PA    = solverEndPA.graphs(1);
    graphNPA    = solverEndPA.graphs(end);
    fprintf('\nPlanar & angle constraints - Chi-squared error: %f\n',solverEndPA.systems(end).chiSquaredError)
    %save results to graph file
    graphNPA.saveGraphFile(config,resultsPAFileName);
    
    %segmented planar & angle constraints
    timeStartSPA = tic;
    graph0SPA    = Graph();
    initialSolSP =  strcat(trialFilePath,sep,'resultsSP.graph');
    solverSPA = graph0SPA.processBatchDiffInitSol(config,measurementsCellSPA,groundTruthCellSPA,initialSolSP);
    totalTimeSPA = toc(timeStartSPA);
    fprintf('\nSegmented planar & angle constraints - total time solving: %f\n',totalTimeSPA)
    solverEndSPA = solverSPA(end);
    graph0SPA    = solverEndSPA.graphs(1);
    graphNSPA    = solverEndSPA.graphs(end);
    fprintf('\nSegmented planar & angle constraints - Chi-squared error: %f\n',solverEndSPA.systems(end).chiSquaredError)
    %save results to graph file
    graphNSPA.saveGraphFile(config,resultsSPAFileName);
    
    fprintf('\nTrial: %d\n',i)
    
end