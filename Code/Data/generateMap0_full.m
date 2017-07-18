function [map] = generateMap0_full(config,camera)
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
%   1.1. Objects
nObjects = 4;
%poses
cube1Pose = [5,5,10,0,0,0]';
cube2Pose = [5,5,10,0,0,0]';
rectangle1Pose = [5,5,0,0,0,0]';
rectangle2Pose = [5,0,5,pi/2,0,0]';
%parameters
cube1Parameters = 10;
cube2Parameters = 10;
rectangle1Parameters = [10,10]';
rectangle2Parameters = [10,10]';
%replicate - same pose & parameters for each time step
cube1Pose = repmat(cube1Pose,1,nSteps);
cube2Pose = repmat(cube2Pose,1,nSteps);
rectangle1Pose = repmat(rectangle1Pose,1,nSteps);
rectangle2Pose = repmat(rectangle2Pose,1,nSteps);
cube1Parameters = repmat(cube1Parameters,1,nSteps);
cube2Parameters = repmat(cube2Parameters,1,nSteps);
rectangle1Parameters = repmat(rectangle1Parameters,1,nSteps);
rectangle2Parameters = repmat(rectangle2Parameters,1,nSteps);
%types
objectTypes = {'cube','cube','rectangle','rectangle'}';
objectPoses = {cube1Pose,cube2Pose,rectangle1Pose,rectangle2Pose}';
objectParameters = {cube1Parameters,cube2Parameters,...
                    rectangle1Parameters,rectangle2Parameters}';

%   1.2. Entities
nEntities = 10;
entityTypes = {'plane','plane','plane','plane','plane','plane',...
               'angle','angle','distance','distance'}';
plane1Parameters = [0,0,1,5]';
plane2Parameters = [0,1,0,0]';
plane3Parameters = [1,0,0,0]';
plane4Parameters = [0,0,1,15]';
plane5Parameters = [0,1,0,10]';
plane6Parameters = [1,0,0,10]';
angle1Parameters = 0; %actually dot product
angle2Parameters = 0;
distance1Parameters = 10;
distance2Parameters = 10;
%replicate - same pose & parameters for each time step
plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
plane4Parameters  = repmat(plane4Parameters,1,nSteps);
plane5Parameters  = repmat(plane5Parameters,1,nSteps);
plane6Parameters  = repmat(plane6Parameters,1,nSteps);
angle1Parameters  = repmat(angle1Parameters,1,nSteps);
angle2Parameters  = repmat(angle2Parameters,1,nSteps);
distance1Parameters = repmat(distance1Parameters,1,nSteps);
distance2Parameters = repmat(distance2Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters,...
                    plane4Parameters,plane5Parameters,plane6Parameters,...
                    angle1Parameters,angle2Parameters,...
                    distance1Parameters,distance2Parameters}';

%   1.3. Points
nPoints = 400;
pointPositions1  = [10*rand(2,50); zeros(1,50)];                   %plane 1
pointPositions2  = [10*rand(1,50); zeros(1,50); 10*rand(1,50)];    %plane 2
pointPositions3  = [zeros(1,50); 10*rand(2,50)];                  %plane 3
pointPositions4  = [10*rand(2,50); 10*ones(1,50)];                 %plane 4
pointPositions5  = [10*rand(1,50); 10*ones(1,50); 10*rand(1,50)];  %plane 5
pointPositions6  = [10*ones(1,50); 10*rand(2,50);];                %plane 6
pointPositions7  = 12*rand(3,100) - ones(3,100);                   %random
pointPositions = [pointPositions1 pointPositions2 pointPositions3 ...
                  pointPositions4 pointPositions5 pointPositions6 pointPositions7];
%shift up 5
pointPositions(3,:) = pointPositions(3,:) + 5;
%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[1:50]',[51:100]',[101:150]',[151:200]',[201:250]',[251:300]',[]',[]',[]',[]'}';
entityChildEntities = {[]',[]',[]',[]',[]',[]',[1 2]',[1 3]',[1 4]',[2 5]'}';
objectPoints = {[1:300]',[]',[1:50]',[51:100]'}';
objectEntities = {[]',[1:6]',[]',[]'}';

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

%	1.4.3. entity-entity
constraints(end+1,:) =  {[]',[7]' ,[1 2]',[]','plane-plane-angle'        ,0}; 
constraints(end+1,:) =  {[]',[8]' ,[1 3]',[]','plane-plane-angle'        ,0};
constraints(end+1,:) =  {[]',[]'  ,[2 3]',[]','plane-plane-fixedAngle'   ,0}; 
constraints(end+1,:) =  {[]',[9]' ,[1 4]',[]','plane-plane-distance'     ,10};
constraints(end+1,:) =  {[]',[10]',[2 5]',[]','plane-plane-distance'     ,10};
constraints(end+1,:) =  {[]',[]'  ,[3 6]',[]','plane-plane-fixedDistance',10};

%   1.4.4. entity-object
%cube 2 planes
cube2Entities = objectEntities{2};
nCube2Entities = size(cube2Entities,1);
for i = 1:nCube2Entities
    constraints(end+1,:) = {2,cube2Entities(i),[],[],'plane-cube',0};
end

%   1.4.5. point-object
%cube 1 points
cube1Points = objectPoints{1};
nCube1Points = size(cube1Points,1);
for i = 1:nCube1Points
    constraints(end+1,:) = {1,[],[],cube1Points(i),'point-cube',0};
end
%rectangle 1 points
rectangle1Points = objectPoints{3};
nRectangle1Points = size(rectangle1Points,1);
for i = 1:nRectangle1Points
    constraints(end+1,:) = {3,[],[],rectangle1Points(i),'point-rectangle',0};
end
%rectangle 2 points
rectangle2Points = objectPoints{4};
nRectangle2Points = size(rectangle2Points,1);
for i = 1:nRectangle2Points
    constraints(end+1,:) = {4,[],[],rectangle2Points(i),'point-rectangle',0};
end

%% 2. initialise map
map = map.initialisePoints(pointPositions);
map = map.initialiseEntities(entityTypes,entityParameters);
map = map.initialiseObjects(objectPoses,objectTypes,objectParameters);
map = map.initialiseConstraints(constraints);

%% 3. remove unobserved features
map = map.removeUnobservedFeatures(config,camera);

end

