function [map] = generateMap_Cube(config,camera) 

nSteps = config.nSteps;
map = Map();

%% 1. generate feature & constraint values

%   1.2. Entities
nEntities = 6;
entityTypes = {'plane','plane','plane','plane','plane','plane'}';
sideLength = 5;% cube side length
plane1Parameters = [1,0,0,0]';
plane3Parameters = [0,1,0,0]';
plane5Parameters = [0,0,1,0]';
plane2Parameters = [1,0,0,sideLength]';
plane4Parameters = [0,1,0,sideLength]';
plane6Parameters = [0,0,1,sideLength]';
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
plane4Parameters  = repmat(plane4Parameters,1,nSteps);
plane5Parameters  = repmat(plane5Parameters,1,nSteps);
plane6Parameters  = repmat(plane6Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters,...
    plane4Parameters,plane5Parameters,plane6Parameters}';

%   1.3. Points
nPoints = 250; % number of points per entity
[points,planes] = generateCubePoints(sideLength, nPoints*nEntities);
pointPositions1  = points(:,planes(1,:)==1); %plane 1
pointPositions2  = points(:,planes(1,:)==2); %plane 2
pointPositions3  = points(:,planes(1,:)==3); %plane 3
pointPositions4  = points(:,planes(1,:)==4); %plane 4
pointPositions5  = points(:,planes(1,:)==5); %plane 5
pointPositions6  = points(:,planes(1,:)==6); %plane 6
pointPositions = [pointPositions1 pointPositions2 pointPositions3...
    pointPositions4 pointPositions5 pointPositions6];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdPointPlane*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nEntities*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);

%   1.4. Constraints
entityPoints = {[find(planes(1,:)==1)]',[find(planes(1,:)==2)]',...
    [find(planes(1,:)==3)]',[find(planes(1,:)==4)]',...
    [find(planes(1,:)==5)]',[find(planes(1,:)==6)]'}';

%   1.4.2. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end
% each 2 opposite sides are parallel
constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle',1}; 
constraints(end+1,:) =  {[]',[]' ,[3 4]',[]','plane-plane-fixedAngle',1}; 
constraints(end+1,:) =  {[]',[]' ,[5 6]',[]','plane-plane-fixedAngle',1}; 
% every plane is perpendicular to all other planes but its opposite side
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 6]',[]','plane-plane-fixedAngle',0}; 

constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[2 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[2 6]',[]','plane-plane-fixedAngle',0}; 

constraints(end+1,:) =  {[]',[]' ,[3 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[3 6]',[]','plane-plane-fixedAngle',0}; 

constraints(end+1,:) =  {[]',[]' ,[4 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[4 6]',[]','plane-plane-fixedAngle',0}; 
%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

