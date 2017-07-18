function [map] = generateMap_GT2(config,camera)
%GENERATEMAP5 generates map class instance
%
%   this map used to test toolbox up to generation of system matrix A
%   Features:
%   -random points
%   -points lying on/close to planes
%   -plane entities composed of points
%   -compound entities representing plane-plane angles and distances
%   -fixed constraints on plane-plane angles and distances

nSteps = config.nSteps;
map = Map();

%% 1. generate feature & constraint values

%   1.2. Entities
nEntities = 2;
entityTypes = {'plane','plane'}';
plane1Parameters = [0,-1,0,0]';
plane2Parameters = [0,-1,0,-1]';
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters}';

%   1.3. Points
nPoints = 3; % number of points per entity 
pointPositions1  = [0,2,4;0,0,0;0,3,3]; %plane 1
pointPositions2  = [0,2,4;1,1,1;0,3,3]; %plane 2
pointPositions = [pointPositions1 pointPositions2];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdPointPlane*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nEntities*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[1:nPoints]',[nPoints+1:nEntities*nPoints]'}';
entityChildEntities = {[]',[]'}';

%   1.4.2. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end

constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle',1}; 


%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

