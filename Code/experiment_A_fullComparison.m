clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
settings = 'corridor';
% settings = 'incrementalTesting';
config = Config(settings);

%% 2. Variable 3
experimentName = 'Experiment_14_FullComparison';
%WHAT WE SAID WE WOULD DO
nTrials = 160;
nVariables = 6;
multipliers = zeros(nVariables,nTrials);
multipliers(1,:) = repmat(1:10,1,16); %rngSeed
multipliers(2,:) = ones(1,nTrials);  %odometry
multipliers(3,:) = repmat(kron([1,5,10,15],ones(1,10)),1,4); %posePoint
multipliers(4,:) = repmat(kron([1,20],ones(1,40)),1,2);
multipliers(5,:) = repmat(kron([1,20],ones(1,40)),1,2);
multipliers(6,:) = repmat(kron([1,50],ones(1,80)),1,1);
%TRY THIS ALSO
% nTrials = 160;
% nVariables = 6;
% multipliers = zeros(nVariables,nTrials);
% multipliers(1,:) = repmat(1:10,1,16); %rngSeed
% multipliers(2,:) = ones(1,nTrials);  %odometry
% multipliers(3,:) = repmat(kron([1,10],ones(1,10)),1,8); %posePoint
% multipliers(4,:) = repmat(kron([1,20],ones(1,20)),1,4);
% multipliers(5,:) = repmat(kron([1,20],ones(1,20)),1,4);
% multipliers(6,:) = repmat(kron([1,10,50,100],ones(1,40)),1,1);

trials = 1:nTrials;
for i = trials
    %% 3. Change trial specific parameters
    %file paths
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end   
    trialFilePath = strcat(experimentName,sep,'Trial_',num2str(i));
    mkdir(strcat('Data',sep,'GraphFiles',sep,trialFilePath));
    groundTruthFileName   = strcat(trialFilePath,sep,'groundTruth.graph');
    groundTruthSFileName  = strcat(trialFilePath,sep,'groundTruthS.graph');
    measurementsFileName  = strcat(trialFilePath,sep,'measurements.graph');
    measurementsSFileName = strcat(trialFilePath,sep,'measurementsS.graph');
    resultsFileName    = strcat(trialFilePath,sep,'results.graph');
    resultsPFileName   = strcat(trialFilePath,sep,'resultsP.graph');
    resultsPAFileName  = strcat(trialFilePath,sep,'resultsPA.graph');
    resultsSPFileName  = strcat(trialFilePath,sep,'resultsSP.graph');
    resultsSPAFileName = strcat(trialFilePath,sep,'resultsSPA.graph');
    
    %set config
    config.displayProgress    = 0;
    config.processing         = 'incremental';
    config.rngSeed            = multipliers(1,i)*1;
    config.stdPosePose        = multipliers(2,i)*[0.02,0.02,0.02,pi/90,pi/90,pi/90]';
    config.stdPosePoint       = multipliers(3,i)*[0.02,0.02,0.02]';
    config.stdPointPlane      = multipliers(4,i)*0.01;
    config.stdSurface         = multipliers(5,i)*0.01;
    config.stdPlanePlaneAngle = multipliers(6,i)*deg2rad(0.05);
    save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'),'config');

    %% 4. Simulate Camera, Environment & Measurements
    if config.simulateData
        camera = config.cameraHandle(config);
        if config.rngSeed; rng(config.rngSeed); end; %fix random noise
        map    = generateMap17_corridorJoined(config,camera);
        if config.rngSeed; rng(config.rngSeed); end; %fix random noise
        mapS   = generateMap14_segmentedCorridor2(config,camera);
        measurements  = Measurements(config,map,camera);
        measurementsS = Measurements(config,mapS,camera);
        constructGroundTruthGraphFile(config,camera,map,measurements,groundTruthFileName);
        constructGroundTruthGraphFile(config,camera,mapS,measurementsS,groundTruthSFileName);
        constructMeasurementsGraphFile(config,camera,measurements,measurementsFileName);
        constructMeasurementsGraphFile(config,camera,measurementsS,measurementsSFileName);
    end

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
    
    fprintf('\nTrial: %d\n',i)
    
end

%% 7. Plot/Save figures
%will figure out autosaving later - need to fix line thickness
%and bounding
% saveFigures(experimentName,trials,config)
