function [map] = generateMap4_switchable(config,camera)
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
nEntities = 1;
entityTypes = {'plane'}';
plane1Parameters = [-1,-2,3,4]';
plane1Parameters = plane1Parameters/norm(plane1Parameters(1:3));
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
entityParameters = {plane1Parameters}';

%   1.3. Points
nPlane1Points = 25;
nRandomPoints = 25;
pointPositions1 = zeros(3,nPlane1Points);
pointPositions1(1:2,:) = [10*rand(2,nPlane1Points)];                   %plane 1
a = plane1Parameters(1); b = plane1Parameters(2); c = plane1Parameters(3); d = plane1Parameters(4);
pointPositions1(3,:)   = (d - a*pointPositions1(1,:) - b*pointPositions1(2,:))/c;
pointPositions2 = 12*rand(3,nRandomPoints) - ones(3,nRandomPoints);                   %random
pointPositions  = [pointPositions1 pointPositions2];
nPoints = size(pointPositions,2);
%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);

%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[1:28]'}';
% entityPoints = {[1:nPlane1Points]'}';
entityChildEntities = {[]'}';

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

