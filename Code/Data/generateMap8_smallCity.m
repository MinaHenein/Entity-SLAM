function [map] = generateMap8_smallCity(config,camera)
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
nEntities = 7;
entityTypes = {'plane','plane','plane','plane','plane','plane','plane'}';
%ground plane
plane1Parameters = [0,0,1,0]';
%left building
plane2Parameters = [1,0,0,-4]';
plane3Parameters = [0,1,0,0]';
plane4Parameters = [0,0,1,10]';
%right building
plane5Parameters = [1,0,0,4]';
plane6Parameters = [0,1,0,5]';
plane7Parameters = [0,0,1,12]';
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
plane4Parameters  = repmat(plane4Parameters,1,nSteps);
plane5Parameters  = repmat(plane5Parameters,1,nSteps);
plane6Parameters  = repmat(plane6Parameters,1,nSteps);
plane7Parameters  = repmat(plane7Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters,plane4Parameters,...
                    plane5Parameters,plane6Parameters,plane7Parameters }';

%   1.3. Points
nGPoints = 15;
nB1XPoints = 10; %normal to x axis
nB1YPoints = 10; %normal to y axis
nB1ZPoints = 10; %normal to z axis
nB2XPoints = 10; %normal to x axis
nB2YPoints = 10; %normal to y axis
nB2ZPoints = 10; %normal to z axis
nB1CornerPoints = 5; %on edge of building 1
iGPoints = 1:nGPoints;
iB1XPoints = iGPoints(end)+1:iGPoints(end)+nB1XPoints;
iB1YPoints = iB1XPoints(end)+1:iB1XPoints(end)+nB1YPoints;
iB1ZPoints = iB1YPoints(end)+1:iB1YPoints(end)+nB1ZPoints;
iB2XPoints = iB1ZPoints(end)+1:iB1ZPoints(end)+nB2XPoints;
iB2YPoints = iB2XPoints(end)+1:iB2XPoints(end)+nB2YPoints;
iB2ZPoints = iB2YPoints(end)+1:iB2YPoints(end)+nB2ZPoints;
iB1CornerPoints = iB2ZPoints(end)+1:iB2ZPoints(end)+nB1CornerPoints;
nPoints = nGPoints + nB1XPoints + nB1YPoints + nB1ZPoints...
          + nB2XPoints + nB2YPoints + nB2ZPoints + nB1CornerPoints;
%ground plane
pointPositions1  = [8*rand(1,nGPoints); 20*rand(1,nGPoints); 0*ones(1,nGPoints)] - [4 0 0]'*ones(1,nGPoints);
mu = zeros(3,1);
sigma = 2*config.stdPointPlane*ones(3,1);
pointPositions1 = addGaussianNoise(mu,sigma,pointPositions1);
%building 1
pointPositions2  = [-4*ones(1,nB1XPoints); 12*rand(1,nB1XPoints); 10*rand(1,nB1XPoints)] - [0 0 0]'*ones(1,nB1XPoints);  %yz
pointPositions3  = [-8*rand(1,nB1YPoints); 0*ones(1,nB1YPoints);  10*rand(1,nB1YPoints)] - [4 0 0]'*ones(1,nB1YPoints);  %xz
pointPositions4  = [-8*rand(1,nB1ZPoints); 10*rand(1,nB1ZPoints); 10*ones(1,nB1YPoints)] - [4 0 0]'*ones(1,nB1ZPoints);  %xy
%building 2
pointPositions5  = [4*ones(1,nB2XPoints); 15*rand(1,nB2XPoints); 12*rand(1,nB2XPoints)] + [0 5 0]'*ones(1,nB2XPoints);  %yz
pointPositions6  = [8*rand(1,nB2YPoints); 0*ones(1,nB2YPoints);  12*rand(1,nB2YPoints)] + [4 5 0]'*ones(1,nB2YPoints);  %xz
pointPositions7  = [8*rand(1,nB2ZPoints); 10*rand(1,nB2ZPoints); 12*ones(1,nB2ZPoints)] + [4 5 0]'*ones(1,nB2ZPoints);  %xy
%corner points on building 1
pointPositions8  = [-8*rand(1,nB1CornerPoints); 0*ones(1,nB1CornerPoints);  0*ones(1,nB1CornerPoints)] + [-4 0 10]'*ones(1,nB1CornerPoints);

pointPositions = [pointPositions1 pointPositions2 pointPositions3 pointPositions4...
                  pointPositions5 pointPositions6 pointPositions7 pointPositions8];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdSurface*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[iGPoints]',[iB1XPoints]',[iB1YPoints iB1CornerPoints]',[iB1ZPoints iB1CornerPoints]',...
                [iB2XPoints]',[iB2YPoints]',[iB2ZPoints]'}';
entityChildEntities = {[]',[]',[]',[]',[]',[]',[]'}';

%   1.4.1. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0,0};
    end
end

%   1.4.2. point-entity
%everything orthogonal/parallel to ground plane
constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle',1}; 
constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 6]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[1 7]',[]','plane-plane-fixedAngle',1}; 
%building 1 planes orthogonal
constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[3 4]',[]','plane-plane-fixedAngle',0}; 
%building 2 planes orthogonal
constraints(end+1,:) =  {[]',[]' ,[5 6]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[5 7]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[6 7]',[]','plane-plane-fixedAngle',0}; 

%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

