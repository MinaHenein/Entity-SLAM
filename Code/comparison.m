clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
% settings = 'incrementalTesting';
% settings = 'smallLoop';
settings = 'corridor';
config = Config(settings);
if config.rngSeed; rng(config.rngSeed); end; %fix random noise

%% 2. Simulate Camera, Environment & Measurements
if config.simulateData
    camera = config.cameraHandle(config);
    map    = config.mapHandle(config,camera); 
    measurements = Measurements(config,map,camera);
    constructGroundTruthGraphFile(config,camera,map,measurements,config.groundTruthFileName);
    constructMeasurementsGraphFile(config,camera,measurements,config.measurementsFileName);
end

%% 3. Load graph files
groundTruthCell  = graphFileToCell(config,config.groundTruthFileName,'noConstraints');
measurementsCell = graphFileToCell(config,config.measurementsFileName,'noConstraints');
groundTruthCellP  = graphFileToCell(config,config.groundTruthFileName,'noAngleConstraints');
measurementsCellP = graphFileToCell(config,config.measurementsFileName,'noAngleConstraints');
groundTruthCellPA  = graphFileToCell(config,config.groundTruthFileName);
measurementsCellPA = graphFileToCell(config,config.measurementsFileName);

%% 4. Solve
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
graphN.saveGraphFile(config,'results.graph');

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
graphNP.saveGraphFile(config,'resultsP.graph');

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
graphNPA.saveGraphFile(config,'resultsPA.graph');

%% 5. Error analysis
%load ground truth into graph, sort if required
graphGT   = Graph(config,groundTruthCell);
graphGTP  = Graph(config,groundTruthCellP);
graphGTPA = Graph(config,groundTruthCellPA);
results   = errorAnalysis(config,graphGT,graphN);
resultsPA = errorAnalysis(config,graphGTPA,graphNPA);
resultsP  = errorAnalysis(config,graphGTPA,graphNP);

%% 6. Plotting
%safer to plot what you have saved
resultsCell = graphFileToCell(config,'results.graph');
resultsCellP = graphFileToCell(config,'resultsP.graph');
resultsCellPA = graphFileToCell(config,'resultsPA.graph');

h = figure; 
subplot(2,3,1)
title('no constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCell,[1 0 0]);
% plotGraphFile(config,initialCell,[0 1 1]);
plotGraphFile(config,resultsCell,[0 0 1])

subplot(2,3,2)
title('planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellP,[1 0 0]);
% plotGraphFile(config,initialCellSC,[0 1 1]);
plotGraphFile(config,resultsCellP,[0 0 1])

subplot(2,3,3)
title('planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellPA,[1 0 0]);
% plotGraphFile(config,initialCellC,[0 1 1]);
plotGraphFile(config,resultsCellPA,[0 0 1])

subplot(2,3,4)
title('no constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCell,[1 0 0]);
% plotGraphFile(config,initialCell,[0 1 1]);
plotGraphFile(config,resultsCell,[0 0 1])

subplot(2,3,5)
title('planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellP,[1 0 0]);
% plotGraphFile(config,initialCellSC,[0 1 1]);
plotGraphFile(config,resultsCellP,[0 0 1])

subplot(2,3,6)
title('planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellPA,[1 0 0]);
% plotGraphFile(config,initialCellC,[0 1 1]);
plotGraphFile(config,resultsCellPA,[0 0 1])

titleCell = {'Comparison',...
            [' (rngSeed = ',num2str(config.rngSeed,3),...
            ', sigmaOdometry = ',mat2str(config.stdPosePose',3),...
            ', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
            ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
            ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
suptitle(titleCell)