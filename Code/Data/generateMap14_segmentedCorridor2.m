function [map] = generateMap14_segmentedCorridor2(config,camera)
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
nEntities = 9;
entityTypes = {'plane','plane','plane','plane','plane','plane','plane','plane','plane'}';
%ground plane
plane1Parameters = [0,0,1,0]';
%left buildings
plane2Parameters = [1,0,0,-4]';
plane3Parameters = [1,0,0,-4]';
plane4Parameters = [1,0,0,-4]';
plane5Parameters = [1,0,0,-4]';
%right buildings
plane6Parameters = [1,0,0,4]';
plane7Parameters = [1,0,0,4]';
plane8Parameters = [1,0,0,4]';
plane9Parameters = [1,0,0,4]';

plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
plane4Parameters  = repmat(plane4Parameters,1,nSteps);
plane5Parameters  = repmat(plane5Parameters,1,nSteps);
plane6Parameters  = repmat(plane6Parameters,1,nSteps);
plane7Parameters  = repmat(plane7Parameters,1,nSteps);
plane8Parameters  = repmat(plane8Parameters,1,nSteps);
plane9Parameters  = repmat(plane9Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters,...
                    plane4Parameters,plane5Parameters,plane6Parameters,...
                    plane7Parameters,plane8Parameters,plane9Parameters}';

%   1.3. Points
nGroundPoints = 100;
nLeft1Points = 25; 
nLeft2Points = 25; 
nLeft3Points = 25; 
nLeft4Points = 25; 
nRight1Points = 25; 
nRight2Points = 25; 
nRight3Points = 25; 
nRight4Points = 25; 
iGroundPoints = 1:nGroundPoints;
iLeft1Points = iGroundPoints(end)+1:iGroundPoints(end)+nLeft1Points;
iLeft2Points = iLeft1Points(end)+1:iLeft1Points(end)+nLeft2Points;
iLeft3Points = iLeft2Points(end)+1:iLeft2Points(end)+nLeft3Points;
iLeft4Points = iLeft3Points(end)+1:iLeft3Points(end)+nLeft4Points;
iRight1Points = iLeft4Points(end)+1:iLeft4Points(end)+nRight1Points;
iRight2Points = iRight1Points(end)+1:iRight1Points(end)+nRight2Points;
iRight3Points = iRight2Points(end)+1:iRight2Points(end)+nRight3Points;
iRight4Points = iRight3Points(end)+1:iRight3Points(end)+nRight4Points;

nPoints = nGroundPoints + nLeft1Points + nLeft2Points + nLeft3Points + nLeft4Points...
          + nRight1Points + nRight2Points + nRight3Points + nRight4Points;
      
%positions
groundPositions  = [8*rand(1,nGroundPoints); 200*rand(1,nGroundPoints); 0*ones(1,nGroundPoints)] + [-4 0 0]'*ones(1,nGroundPoints);
left1Positions  = [-4*ones(1,nLeft1Points); 50*rand(1,nLeft1Points); 10*rand(1,nLeft1Points)] + [0 0 0]'*ones(1,nLeft1Points);  
left2Positions  = [-4*ones(1,nLeft2Points); 50*rand(1,nLeft2Points); 10*rand(1,nLeft2Points)] + [0 50 0]'*ones(1,nLeft2Points);  
left3Positions  = [-4*ones(1,nLeft3Points); 50*rand(1,nLeft3Points); 10*rand(1,nLeft3Points)] + [0 100 0]'*ones(1,nLeft3Points);  
left4Positions  = [-4*ones(1,nLeft4Points); 50*rand(1,nLeft4Points); 10*rand(1,nLeft4Points)] + [0 150 0]'*ones(1,nLeft4Points);  
right1Positions  = [4*ones(1,nRight1Points); 50*rand(1,nRight1Points);  10*rand(1,nRight1Points)] + [0 0 0]'*ones(1,nRight1Points); 
right2Positions  = [4*ones(1,nRight2Points); 50*rand(1,nRight2Points);  10*rand(1,nRight2Points)] + [0 50 0]'*ones(1,nRight2Points);  
right3Positions  = [4*ones(1,nRight3Points); 50*rand(1,nRight3Points);  10*rand(1,nRight3Points)] + [0 100 0]'*ones(1,nRight3Points);  
right4Positions  = [4*ones(1,nRight4Points); 50*rand(1,nRight4Points);  10*rand(1,nRight4Points)] + [0 150 0]'*ones(1,nRight4Points);  
pointPositions = [groundPositions left1Positions left2Positions left3Positions left4Positions...
                  right1Positions right2Positions right3Positions right4Positions];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdSurface*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[iGroundPoints]',[iLeft1Points]',[iLeft2Points]',[iLeft3Points]',[iLeft4Points]',...
                [iRight1Points]',[iRight2Points]',[iRight3Points]',[iRight4Points]'}';
entityChildEntities = {[]',[]',[]',[]',[]',[]',[]',[]',[]'}';

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
% constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 6]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 7]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 8]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[1 9]',[]','plane-plane-fixedAngle'        ,0}; 
% constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[3 4]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[4 5]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[4 6]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[5 6]',[]','plane-plane-fixedAngle'        ,1};
% constraints(end+1,:) =  {[]',[]' ,[6 7]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[7 8]',[]','plane-plane-fixedAngle'        ,1}; 
% constraints(end+1,:) =  {[]',[]' ,[8 9]',[]','plane-plane-fixedAngle'        ,1}; 

constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 6]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 7]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 8]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 9]',[]','plane-plane-fixedAngle'        ,0}; 

constraints(end+1,:) =  {[]',[]' ,[2 6]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[3 7]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[4 8]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[5 9]',[]','plane-plane-fixedAngle'        ,1}; 

constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[2 5]',[]','plane-plane-fixedAngle'        ,1};
constraints(end+1,:) =  {[]',[]' ,[3 4]',[]','plane-plane-fixedAngle'        ,1};
constraints(end+1,:) =  {[]',[]' ,[3 5]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[4 5]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[6 7]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[6 8]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[6 9]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[7 8]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[7 9]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[8 9]',[]','plane-plane-fixedAngle'        ,1}; 

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
