function [map] = generateMap6_angle(config,camera)
%GENERATEMAP5 generates map class instance
%
%   this map used to test toolbox up to generation of system matrix A
%   Features:
%   -random points
%   -points lying on/close to planes of cube
%   -plane entities composed of points
%   -compound entities representing plane-plane angles and distances
%   -fixed constraints on plane-plane angles and distances
%   -cube object consisting of points
%   -cube object consisting of planes
%   -rectangle objects consisting of points

nSteps = config.nSteps;
map = Map();

%% 1. generate feature & constraint values

%   1.2. Entities
nEntities = 3;
entityTypes = {'plane','plane','angle'}';
plane1Parameters = [0,1,0,0]';
plane2Parameters = [1,0,0,0]';
angle1Parameters = 0; %actually dot product
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
angle1Parameters  = repmat(angle1Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,angle1Parameters}';

%   1.3. Points
nPoints = 50;
pointPositions1  = [10*rand(1,25); zeros(1,25); 10*rand(1,25)];                   %plane 1
pointPositions2  = [zeros(1,25); 10*rand(2,25)];    %plane 2
pointPositions = [pointPositions1 pointPositions2];
%shift up 5
pointPositions(3,:) = pointPositions(3,:) + 5;
%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[1:25]',[26:50]',[]'}';
entityChildEntities = {[]',[]',[1 2]'}';

%   1.4.2. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end

constraints(end+1,:) =  {[]',[3]' ,[1 2]',[]','plane-plane-angle',0}; 


%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

