function [map] = generateMap18_largeLoop(config,camera)
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
scale  = config.scale;
assert(mod(nSteps,330)==0)

map = Map();

%% 1. generate feature values
% 1.1. Planes
nEntities = 21;
[entityTypes{1:nEntities,1}] = deal('plane'); 
entityParameters = cell(nEntities,1);
%ground plane
entityParameters{1} = [0,0,1,0]';
%building 1
b1dx = -5*scale; 
b1dy = 25*scale;
entityParameters{2} = [1,0,0,b1dx]';
entityParameters{3} = [0,1,0,b1dy]';
%building 2
b2dx = -50*scale;
b2dy =  95*scale;
entityParameters{4} = [1,0,0,b2dx]';
entityParameters{5} = [0,1,0,b2dy]';
%building 3
b3dx = -105*scale;
entityParameters{6} = [1,0,0,b3dx]';
%building 4
b4dy = 145*scale;
entityParameters{7} = [0,1,0,b4dy]';
%building 5
b5dy = 155*scale;
entityParameters{8} = [0,1,0,b5dy]';
%building 6
b6dx = 65*scale;
entityParameters{9} = [1,0,0,b6dx]';
%building 7
b7dx = 60*scale;
entityParameters{10} = [1,0,0,b7dx]';
%building 8
b8dx = 25*scale;
b8dy = 20*scale;
entityParameters{11} = [0,1,0,b8dy]';
entityParameters{12} = [1,0,0,b8dx]';
%building 9
b9dx = -20*scale;
b9dy =  50*scale;
entityParameters{13} = [0,1,0,b9dy]';
entityParameters{14} = [1,0,0,b9dx]';
%building 10
b10dx  = -65*scale;
b10dy1 = 115*scale;
b10dy2 = 125*scale;
entityParameters{15} = [0,1,0,b10dy1]';
entityParameters{16} = [1,0,0,b10dx]';
entityParameters{17} = [0,1,0,b10dy2]';
%building 11
b11dy = 120*scale;
entityParameters{18} = [0,1,0,b11dy]';
%building 12
b12dx = 35*scale;
b12dy1 = 125*scale;
b12dy2 =  55*scale;
entityParameters{19} = [0,1,0,b12dy1]';
entityParameters{20} = [1,0,0,b12dx]';
entityParameters{21} = [0,1,0,b12dy2]';

%replicate for each time step
for i = 1:nEntities
    entityParameters{i} = repmat(entityParameters{i},1,nSteps);
end

% 1.2. Points

% 1.2.1 number of points for each surface
%ground
nPoints= 100;

% 1.2.2. indexes of points for each surface
nSurfaces = 28;
nSurfacePoints = nPoints*ones(nSurfaces,1)';
surfacePointsEnd = cumsum(nSurfacePoints);

entitiesList = {'G1','G2','G3','G4','G5','G6','G7','G8','B1YZ','B1XZ','B2YZ','B2XZ',...
    'B3YZ','B4XZ','B5XZ','B6YZ','B7YZ','B8XZ','B8YZ','B9XZ','B9YZ','B10XZ1',...
    'B10YZ','B10XZ2','B11XZ','B12XZ1','B12YZ','B12XZ2'};

iG1Points   = iPointsArray('G1',entitiesList,surfacePointsEnd);
iG2Points   = iPointsArray('G2',entitiesList,surfacePointsEnd);
iG3Points   = iPointsArray('G3',entitiesList,surfacePointsEnd);
iG4Points   = iPointsArray('G4',entitiesList,surfacePointsEnd);
iG5Points   = iPointsArray('G5',entitiesList,surfacePointsEnd);
iG6Points   = iPointsArray('G6',entitiesList,surfacePointsEnd);
iG7Points   = iPointsArray('G7',entitiesList,surfacePointsEnd);
iG8Points   = iPointsArray('G8',entitiesList,surfacePointsEnd);
iB1YZPoints = iPointsArray('B1YZ',entitiesList,surfacePointsEnd);
iB1XZPoints = iPointsArray('B1XZ',entitiesList,surfacePointsEnd);
iB2YZPoints = iPointsArray('B2YZ',entitiesList,surfacePointsEnd);
iB2XZPoints = iPointsArray('B2XZ',entitiesList,surfacePointsEnd);
iB3YZPoints = iPointsArray('B3YZ',entitiesList,surfacePointsEnd);
iB4XZPoints = iPointsArray('B4XZ',entitiesList,surfacePointsEnd);
iB5XZPoints = iPointsArray('B5XZ',entitiesList,surfacePointsEnd);
iB6YZPoints = iPointsArray('B6YZ',entitiesList,surfacePointsEnd);
iB7YZPoints = iPointsArray('B7YZ',entitiesList,surfacePointsEnd);
iB8XZPoints = iPointsArray('B8XZ',entitiesList,surfacePointsEnd);
iB8YZPoints = iPointsArray('B8YZ',entitiesList,surfacePointsEnd);
iB9XZPoints = iPointsArray('B9XZ',entitiesList,surfacePointsEnd);
iB9YZPoints = iPointsArray('B9YZ',entitiesList,surfacePointsEnd);
iB10XZ1Points = iPointsArray('B10XZ1',entitiesList,surfacePointsEnd);
iB10YZPoints = iPointsArray('B10YZ',entitiesList,surfacePointsEnd);
iB10XZ2Points = iPointsArray('B10XZ2',entitiesList,surfacePointsEnd);
iB11XZPoints = iPointsArray('B11XZ',entitiesList,surfacePointsEnd);
iB12XZ1Points = iPointsArray('B12XZ1',entitiesList,surfacePointsEnd);
iB12YZPoints = iPointsArray('B12YZ',entitiesList,surfacePointsEnd);
iB12XZ2Points = iPointsArray('B12XZ2',entitiesList,surfacePointsEnd);

% 1.2.3. Positions of points for each surface
%ground
positionsG1   = generatePlanePointsSimulation(nPoints,[0,0,0],30*scale,35*scale,'XY');
positionsG2   = generatePlanePointsSimulation(nPoints,[-50*scale,35*scale,0],50*scale,25*scale,'XY');
positionsG3   = generatePlanePointsSimulation(nPoints,[-50*scale,55*scale,0],25*scale,50*scale,'XY');
positionsG4   = generatePlanePointsSimulation(nPoints,[-110*scale,95*scale,0],85*scale,20*scale,'XY');
positionsG5   = generatePlanePointsSimulation(nPoints,[-110*scale,120*scale,0],25*scale,30*scale,'XY');
positionsG6   = generatePlanePointsSimulation(nPoints,[-110*scale,125*scale,0],155*scale,40*scale,'XY');
positionsG7   = generatePlanePointsSimulation(nPoints,[45*scale,55*scale,0],30*scale,100*scale,'XY');
positionsG8   = generatePlanePointsSimulation(nPoints,[25*scale,35*scale,0],35*scale,30*scale,'XY');
% buildings height
height =  50;
%building 1
start1x = -50*scale;
start1y =  5*scale;
positionsB1YZ = generatePlanePointsSimulation(nPoints,[b1dx,start1y,0],b1dy-start1y,height,'YZ');
positionsB1XZ = generatePlanePointsSimulation(nPoints,[start1x,b1dy,0],b1dx-start1x,height,'XZ');
%building 2
start2x = -75*scale;
start2y =  40*scale;
positionsB2YZ = generatePlanePointsSimulation(nPoints,[b2dx,start2y,0],b2dy-start2y,height,'YZ');
positionsB2XZ = generatePlanePointsSimulation(nPoints,[start2x,b2dy,0],b2dx-start2x,height,'XZ'); 
%building 3
l3 = 20;
positionsB3YZ = generatePlanePointsSimulation(nPoints,[b3dx,-b3dx,0],l3*scale,height-5,'YZ');
%building 4
l4 = 50;
start4x = -70;
positionsB4XZ = generatePlanePointsSimulation(nPoints,[start4x*scale,b4dy,0],l4*scale,height,'XZ');
%building 5
l5 = 40;
start5x = -10;
positionsB5XZ = generatePlanePointsSimulation(nPoints,[start5x*scale,b5dy,0],l5*scale,height,'XZ');
%building 6
l6 = 25;
start6y = 90;
positionsB6YZ = generatePlanePointsSimulation(nPoints,[b6dx,start6y*scale,0],l6*scale,height+5,'YZ');
%building 7
l7 = 15;
positionsB7YZ = generatePlanePointsSimulation(nPoints,[b7dx,65*scale,0],l7*scale,height,'YZ');
%building 8
start8y = 5*scale;
l8 = 30;
positionsB8XZ = generatePlanePointsSimulation(nPoints,[b8dx,b8dy,0],l8*scale,height,'XZ'); 
positionsB8YZ = generatePlanePointsSimulation(nPoints,[b8dx,start8y,0],b8dy-start8y,height,'YZ');
%building 9
l9 = 15;
w9 = 55;
positionsB9XZ = generatePlanePointsSimulation(nPoints,[b9dx,b9dy,0],l9*scale,height-5,'XZ'); 
positionsB9YZ = generatePlanePointsSimulation(nPoints,[b9dx,b9dy,0],w9*scale,height-5,'YZ');
%building 10
l10 = 20*scale;
positionsB10XZ1 = generatePlanePointsSimulation(nPoints,[b10dx,b10dy1,0],l10,height-5,'XZ'); 
positionsB10YZ = generatePlanePointsSimulation(nPoints,[b10dx,b10dy1,0],b10dy2-b10dy1,height-5,'YZ');
positionsB10XZ2 = generatePlanePointsSimulation(nPoints,[b10dx,b10dy2,0],l10,height-5,'XZ'); 
%building 11
l11 = 40*scale;
positionsB11XZ = generatePlanePointsSimulation(nPoints,[-l11,b11dy,0],l11,height,'XZ'); 
%building 12
l12 = 35*scale;
positionsB12XZ1 = generatePlanePointsSimulation(nPoints,[0,b12dy1,0],l12,height+5,'XZ'); 
positionsB12YZ = generatePlanePointsSimulation(nPoints,[b12dx,b12dy2,0],b12dy1-b12dy2,height+5,'YZ');
positionsB12XZ2 = generatePlanePointsSimulation(nPoints,[0,b12dy2,0],l12,height+5,'XZ'); 

pointPositions = [positionsG1,positionsG2,positionsG3,positionsG4,positionsG5,...
    positionsG6,positionsG7,positionsG8,positionsB1YZ,positionsB1XZ,...
    positionsB2YZ,positionsB2XZ,positionsB3YZ,positionsB4XZ,positionsB5XZ,...
    positionsB6YZ,positionsB7YZ,positionsB8XZ,positionsB8YZ,positionsB9XZ,...
    positionsB9YZ,positionsB10XZ1,positionsB10YZ,positionsB10XZ2,positionsB11XZ,...
    positionsB12XZ1,positionsB12YZ,positionsB12XZ2];

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
{[iG1Points,iG2Points,iG3Points,iG4Points,iG5Points,iG6Points,iG7Points,iG8Points]',... 
[iB1YZPoints]',[iB1XZPoints]',...
[iB2YZPoints]',[iB2XZPoints]',...
[iB3YZPoints]',...
[iB4XZPoints]',...
[iB5XZPoints]',...
[iB6YZPoints]',...
[iB7YZPoints]',...
[iB8XZPoints]',[iB8YZPoints]',...
[iB9XZPoints]',[iB9YZPoints]',...
[iB10XZ1Points]',[iB10YZPoints]',[iB10XZ2Points]'...
[iB11XZPoints]',...
[iB12XZ1Points]',[iB12YZPoints]',[iB12XZ2Points]'};              
            
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
%everything orthogonal to ground plane
for i = 2:nEntities
    constraints(end+1,:) =  {[]',[]' ,[1 i]',[]','plane-plane-fixedAngle',0}; 
end
%walls parallel or orthogonal
constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[4 5]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[11 12]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[13 14]',[]','plane-plane-fixedAngle',0}; 
constraints(end+1,:) =  {[]',[]' ,[15 16]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[16 17]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[19 20]',[]','plane-plane-fixedAngle',0};
constraints(end+1,:) =  {[]',[]' ,[20 21]',[]','plane-plane-fixedAngle',0};

constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[4 6]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[6 9]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[9 10]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[10 12]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[12 14]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[14 16]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[16 20]',[]','plane-plane-fixedAngle',1};

constraints(end+1,:) =  {[]',[]' ,[3 5]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[5 7]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[7 8]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[8 11]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[11 13]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[13 15]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[15 17]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[17 18]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[18 19]',[]','plane-plane-fixedAngle',1};
constraints(end+1,:) =  {[]',[]' ,[19 21]',[]','plane-plane-fixedAngle',1};

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
% plotMap(map,[],[1 0 0])

end
