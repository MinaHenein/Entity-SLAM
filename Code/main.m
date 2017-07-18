clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
% settings = 'angularConstraintsTesting';
% settings = 'smallLoop';
% settings = 'largeLoop';
% settings = 'corridor';
% settings = 'city';
settings = 'FreiburgOffice';
% settings = 'realsense';
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
groundTruthCell  = graphFileToCell(config,config.groundTruthFileName);
measurementsCell = graphFileToCell(config,config.measurementsFileName);

%% 4. Solve
%no constraints
timeStart = tic;
graph0 = Graph();
solver = graph0.process(config,measurementsCell,groundTruthCell);
% solver = graph0.processBatchDiffInitSol(config,measurementsCell,groundTruthCell,initSolGraphFile);
solverEnd = solver(end);
totalTime = toc(timeStart);
fprintf('\nTotal time solving: %f\n',totalTime)

%get desired graphs & systems
graph0  = solverEnd.graphs(1);
graphN  = solverEnd.graphs(end);
fprintf('\nChi-squared error: %f\n',solverEnd.systems(end).chiSquaredError)
%save results to graph file
graphN.saveGraphFile(config,'results.graph');

%% 5. Error analysis
%load ground truth into graph, sort if required
graphGT = Graph(config,groundTruthCell);
results = errorAnalysis(config,graphGT,graphN);

%% 6. Plotting
%no constraints
figure
subplot(1,2,1)
spy(solverEnd.systems(end).A)
subplot(1,2,2)
spy(solverEnd.systems(end).H)

h = figure; 
if config.axisEqual; axis equal; end
%axis(config.axisLimits)
%view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
%plot initial solution
plotGraph(config,graph0,[0 1 1]);
%plot groundtruth
plotGraphFile(config,groundTruthCell,[1 0 0]);
%plot results
resultsCell = graphFileToCell(config,'results.graph');
plotGraphFile(config,resultsCell,[0 0 1])
% titleCell = {'Comparison',...
%                [' (rngSeed = ',num2str(config.rngSeed,3),...
%                ', sigmaOdometry = ',mat2str(config.stdPosePose',3),...
%                ', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
%                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
%                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
% title(titleCell)