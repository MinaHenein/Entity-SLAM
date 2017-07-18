clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
settings = 'corridor';
config = Config(settings);

%% 2. Simulate Camera, Environment & Measurements
if config.simulateData
    camera = config.cameraHandle(config);
    if config.rngSeed; rng(config.rngSeed); end; %fix random noise
    map    = generateMap17_corridorJoined(config,camera);
    if config.rngSeed; rng(config.rngSeed); end; %fix random noise
    mapS   = generateMap14_segmentedCorridor2(config,camera);
    measurements  = Measurements(config,map,camera);
    measurementsS = Measurements(config,mapS,camera);
    constructGroundTruthGraphFile(config,camera,map,measurements,'groundTruth.graph');
    constructGroundTruthGraphFile(config,camera,mapS,measurementsS,'groundTruthS.graph');
    constructMeasurementsGraphFile(config,camera,measurements,'measurements.graph');
    constructMeasurementsGraphFile(config,camera,measurementsS,'measurementsS.graph');
end

%% 3. Load graph files
groundTruthCell     = graphFileToCell(config,'groundTruth.graph','noConstraints');
measurementsCell    = graphFileToCell(config,'measurements.graph','noConstraints');
groundTruthCellP    = graphFileToCell(config,'groundTruth.graph','noAngleConstraints');
measurementsCellP   = graphFileToCell(config,'measurements.graph','noAngleConstraints');
groundTruthCellPA   = graphFileToCell(config,'groundTruth.graph');
measurementsCellPA  = graphFileToCell(config,'measurements.graph');
groundTruthCellSP   = graphFileToCell(config,'groundTruthS.graph','noAngleConstraints');
measurementsCellSP  = graphFileToCell(config,'measurementsS.graph','noAngleConstraints');
groundTruthCellSPA  = graphFileToCell(config,'groundTruthS.graph');
measurementsCellSPA = graphFileToCell(config,'measurementsS.graph');

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

nNoI = sum([solver.iterations]);
nPI  = sum([solverP.iterations]);
nPAI = sum([solverPA.iterations]);

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
graphNSP.saveGraphFile(config,'resultsSP.graph');

%segmented planar & angle constraints
timeStartSPA = tic;
graph0SPA    = Graph();
solverSPA    = graph0SPA.process(config,measurementsCellSPA,groundTruthCellSPA);
totalTimeSPA = toc(timeStartSPA);
fprintf('\nSegmented panar & angle constraints - total time solving: %f\n',totalTimeSPA)
solverEndSPA = solverSPA(end);
graph0SPA    = solverEndSPA.graphs(1);
graphNSPA    = solverEndSPA.graphs(end);
fprintf('\nSegmented planar & angle constraints - Chi-squared error: %f\n',solverEndSPA.systems(end).chiSquaredError)
%save results to graph file
graphNSPA.saveGraphFile(config,'resultsSPA.graph');

%% 5. Error analysis
%load ground truth into graph, sort if required
graphGT    = Graph(config,groundTruthCell);
graphGTP   = Graph(config,groundTruthCellP);
graphGTPA  = Graph(config,groundTruthCellPA);
graphGTSP  = Graph(config,groundTruthCellSP);
graphGTSPA = Graph(config,groundTruthCellSPA);
results    = errorAnalysis(config,graphGT,graphN);
resultsP   = errorAnalysis(config,graphGTP,graphNP);
resultsPA  = errorAnalysis(config,graphGTPA,graphNPA);
resultsSP  = errorAnalysis(config,graphGTSP,graphNSP);
resultsSPA = errorAnalysis(config,graphGTSPA,graphNSPA);
%% 6. Plotting
%safer to plot what you have saved
resultsCell    = graphFileToCell(config,'results.graph');
resultsCellP   = graphFileToCell(config,'resultsP.graph');
resultsCellPA  = graphFileToCell(config,'resultsPA.graph');
resultsCellSP  = graphFileToCell(config,'resultsSP.graph');
resultsCellSPA = graphFileToCell(config,'resultsSPA.graph');

h = figure; 

subplot(2,5,1)
title('no constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCell,[1 0 0]);
plotGraphFile(config,resultsCell,[0 0 1])

subplot(2,5,2)
title('planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellP,[1 0 0]);
plotGraphFile(config,resultsCellP,[0 0 1])

subplot(2,5,3)
title('planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellPA,[1 0 0]);
plotGraphFile(config,resultsCellPA,[0 0 1])

subplot(2,5,4)
title('segmented planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSP,[1 0 0]);
plotGraphFile(config,resultsCellSP,[0 0 1])

subplot(2,5,5)
title('segmented planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSPA,[1 0 0]);
plotGraphFile(config,resultsCellSPA,[0 0 1])

subplot(2,5,6)
title('no constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCell,[1 0 0]);
plotGraphFile(config,resultsCell,[0 0 1])

subplot(2,5,7)
title('planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellP,[1 0 0]);
plotGraphFile(config,resultsCellP,[0 0 1])

subplot(2,5,8)
title('planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellPA,[1 0 0]);
plotGraphFile(config,resultsCellPA,[0 0 1])

subplot(2,5,9)
title('planar constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSP,[1 0 0]);
plotGraphFile(config,resultsCellSP,[0 0 1])

subplot(2,5,10)
title('planar & angle constraints')
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view([90 0])
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCellSPA,[1 0 0]);
plotGraphFile(config,resultsCellSPA,[0 0 1])

titleCell = {'Comparison',...
            [' (rngSeed = ',num2str(config.rngSeed,3),...
            ', sigmaOdometry = ',mat2str(config.stdPosePose',3),...
            ', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
            ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
            ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
suptitle(titleCell)