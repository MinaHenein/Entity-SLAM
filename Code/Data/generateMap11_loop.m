function [map] = generateMap11_loop(config,camera)
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

%% 1. generate feature values
% 1.1. Planes
nEntities = 20;
[entityTypes{1:nEntities,1}] = deal('plane'); 
entityParameters = cell(nEntities,1);
%ground plane
entityParameters{1} = [0,0,1,0]';
%building 1
entityParameters{2} = [1,0,0,-4]';
entityParameters{3} = [1,0,0,-56]';
entityParameters{4} = [0,1,0,10]';
entityParameters{5} = [0,1,0,52]';
entityParameters{6} = [0,0,1,15]';
%building 2
entityParameters{7} = [1,0,0,-35]';
entityParameters{8} = [0,1,0,60]';
entityParameters{9} = [0,0,1,10]';
%building 3
entityParameters{10} = [1,0,0,-27]';
entityParameters{11} = [0,1,0,60]';
entityParameters{12} = [0,0,1,18]';
%building 4
entityParameters{13} = [1,0,0,4]';
entityParameters{14} = [0,1,0,52]';
entityParameters{15} = [0,0,1,20]';
%building 5
entityParameters{16} = [1,0,0,-4]';
entityParameters{17} = [1,0,0,-46]';
entityParameters{18} = [0,1,0,20]';
entityParameters{19} = [0,1,0,48]';
entityParameters{20} = [0,0,1,12]';
%replicate for each time step
for i = 1:nEntities
    entityParameters{i} = repmat(entityParameters{i},1,nSteps);
end

% 1.2. Points

% 1.2.1 number of points for each surface
%ground
nG1Points = 25; nG2Points = 25; nG3Points = 25; nG4Points = 25;
%building 1
nB1X1Points = 15; nB1X2Points = 15;
nB1Y1Points = 15; nB1Y2Points = 15;
nB1Z1Points = 15; nB1Z2Points = 15;
%building 2
nB2XPoints = 15;
nB2YPoints = 15;
nB2ZPoints = 15;
%building 3
nB3XPoints = 15;
nB3YPoints = 15;
nB3ZPoints = 15;
%building 4
nB4XPoints = 15;
nB4YPoints = 15;
nB4ZPoints = 15;
%building 5
nB5X1Points = 15; nB5X2Points = 15;
nB5Y1Points = 15; nB5Y2Points = 15;
nB5ZPoints = 25;

% 1.2.2. indexes of points for each surface
nSurfacePoints = [nG1Points,nG2Points,nG3Points,nG4Points,...
                  nB1X1Points,nB1X2Points,nB1Y1Points,nB1Y2Points,nB1Z1Points,nB1Z2Points,...
                  nB2XPoints,nB2YPoints,nB2ZPoints,...
                  nB3XPoints,nB3YPoints,nB3ZPoints,...
                  nB4XPoints,nB4YPoints,nB4ZPoints,...
                  nB5X1Points,nB5X2Points,nB5Y1Points,nB5Y2Points,nB5ZPoints]';
surfacePointsEnd = cumsum(nSurfacePoints);
iG1Points   = 1:surfacePointsEnd(1);
iG2Points   = surfacePointsEnd(1)+1:surfacePointsEnd(2);
iG3Points   = surfacePointsEnd(2)+1:surfacePointsEnd(3);
iG4Points   = surfacePointsEnd(3)+1:surfacePointsEnd(4);
iB1X1Points = surfacePointsEnd(4)+1:surfacePointsEnd(5);
iB1X2Points = surfacePointsEnd(5)+1:surfacePointsEnd(6);
iB1Y1Points = surfacePointsEnd(6)+1:surfacePointsEnd(7);
iB1Y2Points = surfacePointsEnd(7)+1:surfacePointsEnd(8);
iB1Z1Points = surfacePointsEnd(8)+1:surfacePointsEnd(9);
iB1Z2Points = surfacePointsEnd(9)+1:surfacePointsEnd(10);
iB2XPoints  = surfacePointsEnd(10)+1:surfacePointsEnd(11);
iB2YPoints  = surfacePointsEnd(11)+1:surfacePointsEnd(12);
iB2ZPoints  = surfacePointsEnd(12)+1:surfacePointsEnd(13);
iB3XPoints  = surfacePointsEnd(13)+1:surfacePointsEnd(14);
iB3YPoints  = surfacePointsEnd(14)+1:surfacePointsEnd(15);
iB3ZPoints  = surfacePointsEnd(15)+1:surfacePointsEnd(16);
iB4XPoints  = surfacePointsEnd(16)+1:surfacePointsEnd(17);
iB4YPoints  = surfacePointsEnd(17)+1:surfacePointsEnd(18);
iB4ZPoints  = surfacePointsEnd(18)+1:surfacePointsEnd(19);
iB5X1Points = surfacePointsEnd(19)+1:surfacePointsEnd(20);
iB5X2Points = surfacePointsEnd(20)+1:surfacePointsEnd(21);
iB5Y1Points = surfacePointsEnd(21)+1:surfacePointsEnd(22);
iB5Y2Points = surfacePointsEnd(22)+1:surfacePointsEnd(23);
iB5ZPoints  = surfacePointsEnd(23)+1:surfacePointsEnd(24);

% 1.2.3. Positions of points for each surface
positionsG1   = [8*rand(1,nG1Points); 56*rand(1,nG1Points); 0*ones(1,nG1Points)] + [-4,-4,0]'*ones(1,nG1Points);
positionsG2   = [52*rand(1,nG2Points); 10*rand(1,nG2Points); 0*ones(1,nG2Points)] + [-56,10,0]'*ones(1,nG2Points);
positionsG3   = [10*rand(1,nG3Points); 32*rand(1,nG3Points); 0*ones(1,nG3Points)] + [-56,20,0]'*ones(1,nG3Points);
positionsG4   = [84*rand(1,nG4Points); 8*rand(1,nG4Points); 0*ones(1,nG4Points)] + [-70,52,0]'*ones(1,nG4Points);
positionsB1X1 = [-4*ones(1,nB1X1Points); 14*rand(1,nB1X1Points); 15*rand(1,nB1X1Points)] + [0,-4,0]'*ones(1,nB1X1Points);
positionsB1X2 = [-56*ones(1,nB1X2Points); 42*rand(1,nB1X2Points); 15*rand(1,nB1X2Points)] + [0,10,0]'*ones(1,nB1X2Points);
positionsB1Y1 = [52*rand(1,nB1Y1Points); 10*ones(1,nB1Y1Points); 15*rand(1,nB1Y1Points)] + [-56,0,0]'*ones(1,nB1Y1Points);
positionsB1Y2 = [14*rand(1,nB1Y2Points); 52*ones(1,nB1Y2Points); 15*rand(1,nB1Y2Points)] + [-70,0,0]'*ones(1,nB1Y2Points);
positionsB1Z1 = [66*rand(1,nB1Z1Points); 14*rand(1,nB1Z1Points); 15*ones(1,nB1Z1Points)] + [-70,-4,0]'*ones(1,nB1Z1Points);
positionsB1Z2 = [14*rand(1,nB1Z2Points); 42*rand(1,nB1Z2Points); 15*ones(1,nB1Z2Points)] + [-70,10,0]'*ones(1,nB1Z2Points);
positionsB2X  = [-35*ones(1,nB2XPoints); 15*rand(1,nB2XPoints); 10*rand(1,nB2XPoints)] + [0,60,0]'*ones(1,nB2XPoints);
positionsB2Y  = [35*rand(1,nB2YPoints); 60*ones(1,nB2YPoints); 10*rand(1,nB2YPoints)] + [-70,0,0]'*ones(1,nB2YPoints);
positionsB2Z  = [35*rand(1,nB2ZPoints); 15*rand(1,nB2ZPoints); 10*ones(1,nB2ZPoints)] + [-70,60,0]'*ones(1,nB2ZPoints);
positionsB3X  = [-27*ones(1,nB3XPoints); 15*rand(1,nB3XPoints); 18*rand(1,nB3XPoints)] + [0,60,0]'*ones(1,nB3XPoints);
positionsB3Y  = [41*rand(1,nB3YPoints); 60*ones(1,nB3YPoints); 18*rand(1,nB3YPoints)] + [-27,0,0]'*ones(1,nB3YPoints);
positionsB3Z  = [41*rand(1,nB3ZPoints); 15*rand(1,nB3ZPoints); 18*ones(1,nB3ZPoints)] + [-27,60,0]'*ones(1,nB3ZPoints);
positionsB4X  = [4*ones(1,nB4XPoints); 56*rand(1,nB4XPoints); 20*rand(1,nB4XPoints)] + [0,-4,0]'*ones(1,nB4XPoints);
positionsB4Y  = [10*rand(1,nB4YPoints); 52*ones(1,nB4YPoints); 20*rand(1,nB4YPoints)] + [4,0,0]'*ones(1,nB4YPoints);
positionsB4Z  = [10*rand(1,nB4ZPoints); 56*rand(1,nB4ZPoints); 20*ones(1,nB4ZPoints)] + [4,-4,0]'*ones(1,nB4ZPoints);
positionsB5X1 = [-4*ones(1,nB5X1Points); 28*rand(1,nB5X1Points); 12*rand(1,nB5X1Points)] + [0,20,0]'*ones(1,nB5X1Points);
positionsB5X2 = [-46*ones(1,nB5X2Points); 28*rand(1,nB5X2Points); 12*rand(1,nB5X2Points)] + [0,20,0]'*ones(1,nB5X2Points);
positionsB5Y1 = [42*rand(1,nB5Y1Points); 20*ones(1,nB5Y1Points); 12*rand(1,nB5Y1Points)] + [-46,0,0]'*ones(1,nB5Y1Points);
positionsB5Y2 = [42*rand(1,nB5Y2Points); 48*ones(1,nB5Y2Points); 12*rand(1,nB5Y2Points)] + [-46,0,0]'*ones(1,nB5Y2Points);
positionsB5Z  = [42*rand(1,nB5ZPoints); 28*rand(1,nB5ZPoints); 12*ones(1,nB5ZPoints)] + [-46,20,0]'*ones(1,nB5ZPoints);

pointPositions = [positionsG1,positionsG2,positionsG3,positionsG4,positionsB1X1,positionsB1X2,positionsB1Y1,...
                  positionsB1Y2,positionsB1Z1,positionsB1Z2,positionsB2X,positionsB2Y,positionsB2Z,positionsB3X,...
                  positionsB3Y,positionsB3Z,positionsB4X,positionsB4Y,positionsB4Z,positionsB5X1,positionsB5X2,... 
                  positionsB5Y1,positionsB5Y2,positionsB5Z];
nPoints = size(pointPositions,2);
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdSurface*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);

%% 2. constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = ...
{[iG1Points,iG2Points,iG3Points,iG4Points]',... 
[iB1X1Points]',...
[iB1X2Points]',...
[iB1Y1Points]',...
[iB1Y2Points]',...
[iB1Z1Points,iB1Z2Points]',...
[iB2XPoints]',...
[iB2YPoints]',...
[iB2ZPoints]',...
[iB3XPoints]',...
[iB3YPoints]',...
[iB3ZPoints]',...
[iB4XPoints]',...
[iB4YPoints]',...
[iB4ZPoints]',... 
[iB5X1Points]',...
[iB5X2Points]',... 
[iB5Y1Points]',... 
[iB5Y2Points]',...
[iB5ZPoints]'};              
            
entityChildEntities = cell(nEntities,1);

%   1.4.1. point-entity
constraints = cell(0,6);
for i = 1:nEntities
    iEntityPoints = entityPoints{i};
    nEntityPoints = size(iEntityPoints,1);
    for j = 1:nEntityPoints
        constraints(end+1,:) = {[],i,[],iEntityPoints(j),'point-plane',0};
    end
end

%   1.4.2. entity-entity
%everything orthogonal/parallel to ground plane
constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 6]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[1 7]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 8]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 9]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[1 10]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 11]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 12]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[1 13]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 14]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 15]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[1 16]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 17]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 18]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 19]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[1 20]',[]','plane-plane-fixedAngle',1};

%walls parallel or orthogonal
constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[3 5]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[5 8]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[7 8]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[7 10]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[10 11]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[11 14]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[13 14]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[13 16]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[16 17]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[16 18]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[16 19]',[]','plane-plane-fixedAngle',1};

%% 3. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseConstraints(constraints);

%% 4. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

%% 5. display
% figure 
% axis equal
% view(-19,43)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold on
% plotMap(map,camera,[1 0 0])

end

