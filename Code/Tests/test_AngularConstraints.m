function test_AngularConstraints(i,j)

addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
settings = 'corridor';
config = Config(settings);

%% 2. Variable 3
nTrials = 160;
nVariables = 6;
multipliers = zeros(nVariables,nTrials);
multipliers(1,:) = repmat(1:10,1,16); %rngSeed
multipliers(2,:) = ones(1,nTrials);  %odometry
multipliers(3,:) = repmat(kron([1,5,10,15],ones(1,10)),1,4); %posePoint
multipliers(4,:) = repmat(kron([1,20],ones(1,40)),1,2);
multipliers(5,:) = repmat(kron([1,20],ones(1,40)),1,2);
multipliers(6,:) = repmat(kron([1,50],ones(1,80)),1,1);

%% 3. Change trial specific parameters
%file paths
if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end
trialFilePath = strcat('Trial_',num2str(i));
groundTruthFileName   = strcat(trialFilePath,sep,'groundTruth.graph');
groundTruthSFileName  = strcat(trialFilePath,sep,'groundTruthS.graph');

switch j
    case 1
    measurementsFileName  = strcat(trialFilePath,sep,'measurements.graph');
    measurementsSFileName = strcat(trialFilePath,sep,'measurementsS.graph');
    case 2
    deleteVerticesFromGraphFile(strcat(pwd,sep,'Data',sep,'GraphFiles',sep,trialFilePath,sep,'results1.graph'));
    measurementsFileName  = strcat(trialFilePath,sep,'results1.graph');
    measurementsSFileName = strcat(trialFilePath,sep,'results1.graph');
    case 3
    deleteVerticesFromGraphFile(strcat(pwd,sep,'Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsP1.graph'));
    deleteVerticesFromGraphFile(strcat(pwd,sep,'Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsSP1.graph'));
    measurementsFileName  = strcat(trialFilePath,sep,'resultsP1.graph');
    measurementsSFileName  = strcat(trialFilePath,sep,'resultsSP1.graph');
end    

resultsFileNameInit = strcat(trialFilePath,sep,'results',num2str(j),'_init.graph');
resultsFileName = strcat(trialFilePath,sep,'results',num2str(j),'.graph');
resultsPFileNameInit = strcat(trialFilePath,sep,'resultsP',num2str(j),'_init.graph');
resultsPFileName = strcat(trialFilePath,sep,'resultsP',num2str(j),'.graph');
resultsPAFileNameInit  = strcat(trialFilePath,sep,'resultsPA',num2str(j),'_init.graph');
resultsPAFileName  = strcat(trialFilePath,sep,'resultsPA',num2str(j),'.graph');
resultsSPFileNameInit = strcat(trialFilePath,sep,'resultsSP',num2str(j),'_init.graph');
resultsSPFileName = strcat(trialFilePath,sep,'resultsSP',num2str(j),'.graph');
resultsSPAFileNameInit = strcat(trialFilePath,sep,'resultsSPA',num2str(j),'_init.graph');
resultsSPAFileName = strcat(trialFilePath,sep,'resultsSPA',num2str(j),'.graph');

%set config
config.displayProgress    = 0;
config.processing         = 'batch';
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
     switch j
         case 1
             constructMeasurementsGraphFile(config,camera,measurements,measurementsFileName);
             constructMeasurementsGraphFile(config,camera,measurementsS,measurementsSFileName);
     end
 end

%% 5. Load graph files
switch j
    case 1
groundTruthCell     = graphFileToCell(config,groundTruthFileName,'noConstraints');
measurementsCell    = graphFileToCell(config,measurementsFileName,'noConstraints');
groundTruthCellP    = graphFileToCell(config,groundTruthFileName,'noAngleConstraints');
measurementsCellP   = graphFileToCell(config,measurementsFileName,'noAngleConstraints'); 
groundTruthCellSP   = graphFileToCell(config,groundTruthSFileName,'noAngleConstraints');
measurementsCellSP  = graphFileToCell(config,measurementsSFileName,'noAngleConstraints');
groundTruthCellPA   = graphFileToCell(config,groundTruthFileName);
measurementsCellPA  = graphFileToCell(config,measurementsFileName);
groundTruthCellSPA  = graphFileToCell(config,groundTruthSFileName);
measurementsCellSPA = graphFileToCell(config,measurementsSFileName);
    case {2,3}
groundTruthCellPA   = graphFileToCell(config,groundTruthFileName);
measurementsCellPA  = graphFileToCell(config,measurementsFileName);
groundTruthCellSPA  = graphFileToCell(config,groundTruthSFileName);
measurementsCellSPA = graphFileToCell(config,measurementsSFileName);
end
%% 6. Solve
%no constraints
switch j
    case 1
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
graph0.saveGraphFile(config,resultsFileNameInit);
graphN.saveGraphFile(config,resultsFileName);
% compute and save errors
graphGT = Graph(config,groundTruthCell);
results = errorAnalysis(config,graphGT,graphN);
save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'results',num2str(j)),'results');

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
graph0P.saveGraphFile(config,resultsPFileNameInit);
graphNP.saveGraphFile(config,resultsPFileName);
% compute and save errors
graphPGT = Graph(config,groundTruthCellP);
resultsP = errorAnalysis(config,graphPGT,graphNP);
save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsP',num2str(j)),'resultsP');

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
graph0SP.saveGraphFile(config,resultsSPFileNameInit);
graphNSP.saveGraphFile(config,resultsSPFileName);
% compute and save errors
graphSPGT = Graph(config,groundTruthCellSP);
resultsSP = errorAnalysis(config,graphSPGT,graphNSP);
save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsSP',num2str(j)),'resultsSP');
end

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
graph0PA.saveGraphFile(config,resultsPAFileNameInit);
graphNPA.saveGraphFile(config,resultsPAFileName);
% compute and save errors
graphPAGT = Graph(config,groundTruthCellPA);
resultsPA = errorAnalysis(config,graphPAGT,graphNPA);
save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsPA',num2str(j)),'resultsPA');

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
graph0SPA.saveGraphFile(config,resultsSPAFileNameInit);
graphNSPA.saveGraphFile(config,resultsSPAFileName);
% compute and save errors
graphSPAGT = Graph(config,groundTruthCellSPA);
resultsSPA = errorAnalysis(config,graphSPAGT,graphNSPA);
save(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'resultsSPA',num2str(j)),'resultsSPA');

h = figure; 
if config.axisEqual; axis equal; end
%axis(config.axisLimits)
%view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSPA,[1 0 0]);
resultsCell = graphFileToCell(config,resultsSPAFileNameInit);
plotGraphFile(config,resultsCell,[0 0 1])
% titleCell = {'Comparison',...
%                [' (rngSeed = ',num2str(config.rngSeed,3),...
%                ', sigmaOdometry = ',mat2str(config.stdPosePose',3),...
%                ', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
%                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
%                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
% title(titleCell)
title(strcat('Trial ',num2str(i),sep,'resultsSPA-init',num2str(j)'))

h = figure; 
if config.axisEqual; axis equal; end
%axis(config.axisLimits)
%view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSPA,[1 0 0]);
resultsCell = graphFileToCell(config,resultsSPAFileName);
plotGraphFile(config,resultsCell,[0 0 1])
title(strcat('Trial ',num2str(i),sep,'resultsSPA',num2str(j)'))

end




