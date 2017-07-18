function [map] = generateMap2_planes(config,camera)
%GENERATEMAP5 generates map class instance
%
%   this map used to test toolbox up to generation of system matrix A
%   Features:
%   -random points
%   -points lying on/close to planes
%   -plane entities composed of points

nSteps = config.nSteps;
map = Map();

%% 1. generate feature & constraint values
%   1.2. Entities
nEntities = 3;
entityTypes = {'plane','plane','plane'}';
plane1Parameters = [0,0,1,0]';
plane2Parameters = [0,1,0,0]';
plane3Parameters = [1,0,0,0]';

%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);

entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters}';

%   1.3. Points
nPoints = 100;
pointPositions1  = [10*rand(2,25); zeros(1,25)];                   %plane 1
pointPositions2  = [10*rand(1,25); zeros(1,25); 10*rand(1,25)];    %plane 2
pointPositions3  = [zeros(1,25); 10*rand(2,25);];                  %plane 3
pointPositions4  = 12*rand(3,25) - ones(3,25);                   %random
pointPositions = [pointPositions1 pointPositions2 pointPositions3 pointPositions4];
mu = zeros(3,1);
sigma = config.stdPointPlane*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);
%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);

%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[1:25]',[26:50]',[51:75]'}';
entityChildEntities = {[]',[]',[]'}';

%	1.4.1. point-point constraints
%NONE

%   1.4.2. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end

%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

