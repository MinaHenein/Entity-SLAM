function [map] = generateMap1_points(config,camera)
%GENERATEMAP5 generates map class instance
%
%   this map used to test toolbox up to generation of system matrix A
%   Features:
%   -random points

nSteps = config.nSteps;
map = Map();

%% 1. generate features
%   1.1. Points
nPoints = 100;
pointPositions  = 10*rand(3,nPoints);                 %random

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%% 2. initialise map
map = map.initialisePoints(pointPositions);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

