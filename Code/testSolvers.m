clear all
% close all
addpath(genpath(pwd))

%loads measurements,ground truth and initial linearisation points for batch
%solving of corridor simulation with high point measurement error (sigma = 0.4m)
%solvers are in Classes\@NonlinearSolver\

%% 1. Load
if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end   
% load(strcat('Data',sep,'SolverTesting',sep,'LMTesting2.mat')); %no constraints
load(strcat('Data',sep,'SolverTesting',sep,'constraintTesting.mat')); %no constraints

%settings from config that you may want to change
% config.solverType = 'Gauss-Newton';
config.solverType = 'Levenberg-Marquardt';
% config.solverType = 'Dog-Leg';
config.maxIterations = 32;
config.automaticAngleConstraints = 1;

%% 2. Solve
solver = NonlinearSolver(config);
solver = solver.solve(config,graph0,measurementsCell);
graphN = solver(end).graphs(end);
fprintf('\nChi-squared error: %f\n',solver.systems(end).chiSquaredError)

%% 3. Plot
figure 
if config.axisEqual; axis equal; end
axis(config.axisLimits)
view(config.plotView)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
plotGraphFile(config,groundTruthCell,[1 0 0]);
plotGraph(config,graphN,[0 0 1]);
