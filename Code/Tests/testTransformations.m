%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Unit test for transformations (simulating measurements, using measurements
%to compute linearisation points)
%
%Should converge instantly, plots should align, error should be 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Initialisation
%   1.1. global variables
settings = 'batchTesting';
config = Config(settings);
rng(config.rngSeed); %fix random noise
%turn measurement noise off
config.noiseSwitch = 'off';

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
results = errorAnalysis(config,graphGT,graphN); %these calculations not right!

%sort
[graphGTSorted] = graphGT.sortVerticesSimple();
[graphNSorted] = graphN.sortVerticesSimple();
for i = 1:graphGT.nVertices
    %different check for planes
    if strcmp(graphGTSorted.vertices(i).type,'plane')
        n1 = graphGTSorted.vertices(i).value(1:3);
        d1 = graphNSorted.vertices(i).value(4);
        n2 = graphGTSorted.vertices(i).value(1:3);
        d2 = graphNSorted.vertices(i).value(4);
        assert(norm(n1*d1 - n2*d2) < 1e-4)
    else
        assert(norm(graphGTSorted.vertices(i).value-graphNSorted.vertices(i).value) < 1e-4)
    end
end

%% 6. Plotting
figure 
% axis equal
view(-19,43)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
% plotGraph(graphGT,[1 0 0]);
plotGraphFile(config,groundTruthCell,[1 0 0]);
% plotGraph(graph0,[0 1 1]);
%plotGraph(graphN,[0 0 1]);
resultsCell = graphFileToCell(config,'results.graph');
plotGraphFile(config,resultsCell,[0 0 1])
