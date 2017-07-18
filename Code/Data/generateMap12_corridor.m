function [map] = generateMap12_corridor(config,camera)
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
nEntities = 3;
entityTypes = {'plane','plane','plane'}';
%ground plane
plane1Parameters = [0,0,1,0]';
%left building
width = 8;
length = 200;
plane2Parameters = [1,0,0,-width/2]';
plane3Parameters = [1,0,0,width/2]';
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters}';

%   1.3. Points
nGroundPoints = 100;
nLeftPoints = 100; %normal to x axis
nRightPoints = 100; %normal to y axis
iGroundPoints = 1:nGroundPoints;
iLeftPoints = iGroundPoints(end)+1:iGroundPoints(end)+nLeftPoints;
iRightPoints = iLeftPoints(end)+1:iLeftPoints(end)+nRightPoints;
nPoints = nGroundPoints + nLeftPoints + nRightPoints;
%positions
groundPositions  = [width*rand(1,nGroundPoints); length*rand(1,nGroundPoints); 0*ones(1,nGroundPoints)] + [-width/2 0 0]'*ones(1,nGroundPoints);
leftPositions  = [-width/2*ones(1,nLeftPoints); length*rand(1,nLeftPoints); 10*rand(1,nLeftPoints)] + [0 0 0]'*ones(1,nLeftPoints);  
rightPositions  = [width/2*ones(1,nRightPoints); length*rand(1,nRightPoints);  10*rand(1,nRightPoints)] + [0 0 0]'*ones(1,nRightPoints);  
pointPositions = [groundPositions leftPositions rightPositions];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdSurface*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[iGroundPoints]',[iLeftPoints]',[iRightPoints]'}';
entityChildEntities = {[]',[]',[]'}';

%   1.4.1. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end

%   1.4.2. point-entity
constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle',1}; 

%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

% figure 
% axis equal
% view(-19,43)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold on
% plotMap(map,camera,[1 0 0])

end

