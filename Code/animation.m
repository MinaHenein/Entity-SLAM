addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
settings = 'smallLoop';
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
solverEndPAI = solver(end);
totalTime = toc(timeStart);
fprintf('\nTotal time solving: %f\n',totalTime)

%get desired graphs & systems
graph0  = solverEndPAI.graphs(1);
graphN  = solverEndPAI.graphs(end);
fprintf('\nChi-squared error: %f\n',solverEndPAI.systems(end).chiSquaredError)
%save results to graph file
graphN.saveGraphFile(config,'results.graph');

%% 5. Error analysis
%load ground truth into graph, sort if required
graphGT = Graph(config,groundTruthCell);
resultsPAI = errorAnalysis(config,graphGT,graphN);