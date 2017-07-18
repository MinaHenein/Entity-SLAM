% This experiment aims at trying some of the cases that caused the
% estimation to break when applying planar and angular constraints.
% It aims at running those cases starting from the solutions of 1-no
% constraints & 2-planar constraints.

clear all
clear classes
% close all
addpath(genpath(pwd))

experimentPath = 'Experiment_14_PlanarAngularInfo';

trials = [2,14,20,21,26,27,28,30,31,37,38,39,40,41,42,44,45,47,50,...
     51,55,57,59,65,67,69,72,75,79,80,101,106,112,116,117,118,119,120,122,...
     132,133,134,139,142,144,145,147,149,152,153,154,155,158,159];

for i = 1:length(trials)
    
    
    %% 3. Change trial specific parameters
    %file paths
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(trials(i)));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path
        
    groundTruthFileName   = strcat(trialFilePath,sep,'groundTruth.graph');
    groundTruthSFileName  = strcat(trialFilePath,sep,'groundTruthS.graph');
    measurementsFileName  = strcat(trialFilePath,sep,'measurements.graph');
    measurementsSFileName = strcat(trialFilePath,sep,'measurementsS.graph');
    resultsFileName    = strcat(trialFilePath,sep,'results.graph');
    resultsPFileName   = strcat(trialFilePath,sep,'resultsP.graph');
    resultsPAFileName  = strcat(trialFilePath,sep,'resultsPA.graph');
    resultsPANoCFileName  = strcat(trialFilePath,sep,'resultsPANoC.graph');
    resultsPAPCFileName  = strcat(trialFilePath,sep,'resultsPAPC.graph');
    resultsSPFileName  = strcat(trialFilePath,sep,'resultsSP.graph');
    resultsSPAFileName = strcat(trialFilePath,sep,'resultsSPA.graph');
    resultsSPANoCFileName = strcat(trialFilePath,sep,'resultsSPANoC.graph');
    resultsSPASPCFileName = strcat(trialFilePath,sep,'resultsSPASPC.graph');
    
    
    %% 5. Load graph files
    groundTruthCell     = graphFileToCell(config,groundTruthFileName,'noConstraints');
    measurementsCell    = graphFileToCell(config,measurementsFileName,'noConstraints');
    groundTruthCellP    = graphFileToCell(config,groundTruthFileName,'noAngleConstraints');
    measurementsCellP   = graphFileToCell(config,measurementsFileName,'noAngleConstraints');
    groundTruthCellPA   = graphFileToCell(config,groundTruthFileName);
    measurementsCellPA  = graphFileToCell(config,measurementsFileName);
    groundTruthCellSP   = graphFileToCell(config,groundTruthSFileName,'noAngleConstraints');
    measurementsCellSP  = graphFileToCell(config,measurementsSFileName,'noAngleConstraints');
    groundTruthCellSPA  = graphFileToCell(config,groundTruthSFileName);
    measurementsCellSPA = graphFileToCell(config,measurementsSFileName);
    
    %% 6. Solve
    %no constraints
    timeStart = tic;
    graph0    = Graph();
    solver    = graph0.process(config,measurementsCell,groundTruthCell);
    totalTime = toc(timeStart);
    fprintf('\nNo constraints - total time solving: %f\n',totalTime)
    solverEnd = solver(end);
    graph0    = solverEnd.graphs(1);
    graphN    = solverEnd.graphs(end);
    fprintf('\nNo constraints - Chi-squared error: %f\n',solverEnd.systems(end).chiSquaredError)
    %save results to graph file
    graphN.saveGraphFile(config,resultsFileName);
    
    %planar constraints
    timeStartP = tic;
    graph0P    = Graph();
    solverP    = graph0P.process(config,measurementsCellP,groundTruthCellP);
    totalTimeP = toc(timeStartP);
    fprintf('\nPlanar constraints - total time solving: %f\n',totalTimeP)
    solverEndP = solverP(end);
    graph0P    = solverEndP.graphs(1);
    graphNP    = solverEndP.graphs(end);
    fprintf('\nPlanar constraints - Chi-squared error: %f\n',solverEndP.systems(end).chiSquaredError)
    %save results to graph file
    graphNP.saveGraphFile(config,resultsPFileName);
    
    %planar & angle constraints
    timeStartPA = tic;
    graph0PA    = Graph();
    solverPA    = graph0PA.process(config,measurementsCellPA,groundTruthCellPA);
    totalTimePA = toc(timeStartPA);
    fprintf('\nPlanar & angle constraints - total time solving: %f\n',totalTimePA)
    solverEndPA = solverPA(end);
    graph0PA    = solverEndPA.graphs(1);
    graphNPA    = solverEndPA.graphs(end);
    fprintf('\nPlanar & angle constraints - Chi-squared error: %f\n',solverEndPA.systems(end).chiSquaredError)
    %save results to graph file
    graphNPA.saveGraphFile(config,resultsPAFileName);
    
    %planar & angle constraints starting from no constraints solution
    timeStartPANoC = tic;
    graph0PANoC    = Graph();
    noConstraintsResultsGraph = strcat(trialFilePath,sep,'results.graph');
    solverPANoC    = graph0PANoC.processBatchDiffInitSol(config,measurementsCellPA,groundTruthCellPA,noConstraintsResultsGraph);
    totalTimePANoC = toc(timeStartPANoC);
    fprintf('\nPlanar & angle constraints starting from no constraints solution- total time solving: %f\n',totalTimePANoC)
    solverEndPANoC = solverPANoC(end);
    graph0PANoC    = solverEndPANoC.graphs(1);
    graphNPANoC    = solverEndPANoC.graphs(end);
    fprintf('\nPlanar & angle constraints starting from no constraints solution- Chi-squared error: %f\n',solverEndPANoC.systems(end).chiSquaredError)
    %save results to graph file
    graphNPANoC.saveGraphFile(config,resultsPANoCFileName);
    
    %planar & angle constraints starting from planar constraints solution
    timeStartPAPC = tic;
    graph0PAPC    = Graph();
    planarConstraintsResultsGraph = strcat(trialFilePath,sep,'resultsP.graph');
    solverPAPC    = graph0PAPC.processBatchDiffInitSol(config,measurementsCellPA,groundTruthCellPA,planarConstraintsResultsGraph);
    totalTimePAPC = toc(timeStartPAPC);
    fprintf('\nPlanar & angle constraints starting from planar constraints solution- total time solving: %f\n',totalTimePAPC)
    solverEndPAPC = solverPAPC(end);
    graph0PAPC    = solverEndPAPC.graphs(1);
    graphNPAPC    = solverEndPAPC.graphs(end);
    fprintf('\nPlanar & angle constraints starting from planar constraints solution- Chi-squared error: %f\n',solverEndPAPC.systems(end).chiSquaredError)
    %save results to graph file
    graphNPAPC.saveGraphFile(config,resultsPAPCFileName);
    
    
    %segmented planar constraints
    timeStartSP = tic;
    graph0SP    = Graph();
    solverSP    = graph0SP.process(config,measurementsCellSP,groundTruthCellSP);
    totalTimeSP = toc(timeStartSP);
    fprintf('\nSegmented planar constraints - total time solving: %f\n',totalTimeSP)
    solverEndSP = solverSP(end);
    graph0SP    = solverEndSP.graphs(1);
    graphNSP    = solverEndSP.graphs(end);
    fprintf('\nSegmented planar constraints - Chi-squared error: %f\n',solverEndSP.systems(end).chiSquaredError)
    %save results to graph file
    graphNSP.saveGraphFile(config,resultsSPFileName);
    
    %segmented planar & angle constraints
    timeStartSPA = tic;
    graph0SPA    = Graph();
    solverSPA    = graph0SPA.process(config,measurementsCellSPA,groundTruthCellSPA);
    totalTimeSPA = toc(timeStartSPA);
    fprintf('\nSegmented planar & angle constraints - total time solving: %f\n',totalTimeSPA)
    solverEndSPA = solverSPA(end);
    graph0SPA    = solverEndSPA.graphs(1);
    graphNSPA    = solverEndSPA.graphs(end);
    fprintf('\nSegmented planar & angle constraints - Chi-squared error: %f\n',solverEndSPA.systems(end).chiSquaredError)
    %save results to graph file
    graphNSPA.saveGraphFile(config,resultsSPAFileName);
    
    %segmented planar & angle constraints starting from no constraints
    %solution
    timeStartSPANoC = tic;
    graph0SPANoC    = Graph();
    solverSPANoC    = graph0SPANoC.processBatchDiffInitSol(config,measurementsCellSPA,groundTruthCellSPA,noConstraintsResultsGraph);
    totalTimeSPANoC = toc(timeStartSPANoC);
    fprintf('\nSegmented planar & angle constraints starting from no constraints solution- total time solving: %f\n',totalTimeSPANoC)
    solverEndSPANoC = solverSPANoC(end);
    graph0SPANoC    = solverEndSPANoC.graphs(1);
    graphNSPANoC    = solverEndSPANoC.graphs(end);
    fprintf('\nSegmented planar & angle constraints starting from no constraints solution- Chi-squared error: %f\n',solverEndSPANoC.systems(end).chiSquaredError)
    %save results to graph file
    graphNSPANoC.saveGraphFile(config,resultsSPANoCFileName);
    
    %segmented planar & angle constraints starting from segmented planar
    %constraonts solution
    timeStartSPASPC = tic;
    graph0SPASPC    = Graph();
    segPlanarConstraintsResultsGraph = strcat(trialFilePath,sep,'resultsSP.graph');
    solverSPASPC    = graph0SPASPC.processBatchDiffInitSol(config,measurementsCellSPA,groundTruthCellSPA,segPlanarConstraintsResultsGraph);
    totalTimeSPASPC = toc(timeStartSPASPC);
    fprintf('\nSegmented planar & angle constraints starting from segemented planar constraints solution- total time solving: %f\n',totalTimeSPASPC)
    solverEndSPASPC = solverSPASPC(end);
    graph0SPASPC    = solverEndSPASPC.graphs(1);
    graphNSPASPC    = solverEndSPASPC.graphs(end);
    fprintf('\nSegmented planar & angle constraints starting from segemented planar constraints solution - Chi-squared error: %f\n',solverEndSPASPC.systems(end).chiSquaredError)
    %save results to graph file
    graphNSPASPC.saveGraphFile(config,resultsSPASPCFileName);
    
    
    fprintf('\nTrial: %d\n', trials(i))
end