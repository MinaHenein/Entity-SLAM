function [map] = generateMap15_corner(config,camera)
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
nEntities = 5;
entityTypes = {'plane','plane','plane','plane','plane'}';
plane1Parameters = [0,0,1,0]';
plane2Parameters = [1,0,0,-4]';
plane3Parameters = [1,0,0,4]';
plane4Parameters = [0,1,0,108]';
plane5Parameters = [0,1,0,100]';

plane1Parameters  = repmat(plane1Parameters,1,nSteps);
plane2Parameters  = repmat(plane2Parameters,1,nSteps);
plane3Parameters  = repmat(plane3Parameters,1,nSteps);
plane4Parameters  = repmat(plane4Parameters,1,nSteps);
plane5Parameters  = repmat(plane5Parameters,1,nSteps);
entityParameters = {plane1Parameters,plane2Parameters,plane3Parameters,...
                    plane4Parameters,plane5Parameters}';

%   1.3. Points
nGround1Points = 100;
nGround2Points = 100;
nLeft1Points = 50; 
nLeft2Points = 50; 
nRight1Points = 50; 
nRight2Points = 50; 
iGround1Points = 1:nGround1Points;
iGround2Points = iGround1Points(end)+1:iGround1Points(end)+nGround2Points;
iLeft1Points = iGround2Points(end)+1:iGround2Points(end)+nLeft1Points;
iRight1Points = iLeft1Points(end)+1:iLeft1Points(end)+nRight1Points;
iLeft2Points = iRight1Points(end)+1:iRight1Points(end)+nLeft2Points;
iRight2Points = iLeft2Points(end)+1:iLeft2Points(end)+nRight2Points;

nPoints = nGround1Points + nGround2Points + nLeft1Points + nLeft2Points + nRight1Points + nRight2Points;
      
%positions
ground1Positions  = [8*rand(1,nGround1Points); 100*rand(1,nGround1Points); 0*ones(1,nGround1Points)] + [-4 0 0]'*ones(1,nGround1Points);
ground2Positions  = [108*rand(1,nGround2Points); 8*rand(1,nGround2Points); 0*ones(1,nGround2Points)] + [-4 100 0]'*ones(1,nGround2Points);
left1Positions  = [-4*ones(1,nLeft1Points); 108*rand(1,nLeft1Points); 10*rand(1,nLeft1Points)] + [0 0 0]'*ones(1,nLeft1Points);  
right1Positions  = [4*ones(1,nRight1Points); 100*rand(1,nRight1Points); 10*rand(1,nRight1Points)] + [0 0 0]'*ones(1,nRight1Points);  
left2Positions  = [108*rand(1,nLeft2Points); 108*ones(1,nLeft2Points);  10*rand(1,nLeft2Points)] + [-4 0 0]'*ones(1,nLeft2Points); 
right2Positions  = [100*rand(1,nRight2Points); 100*ones(1,nRight2Points);  10*rand(1,nRight2Points)] + [4 0 0]'*ones(1,nRight2Points);  
pointPositions = [ground1Positions ground2Positions left1Positions right1Positions left2Positions right2Positions];
%***add noise to GT
mu = zeros(3,1);
sigma = config.stdSurface*ones(3,1);
pointPositions = addGaussianNoise(config,mu,sigma,pointPositions);

%replicate - same pose & parameters for each time step
pointPositions = reshape(pointPositions,3*nPoints,1);
pointPositions = repmat(pointPositions,1,nSteps);
             
%   1.4. Constraints
%constraint = {iObjects,iParentEntities,iChildEntities,iPoints,type,value,switchable}
entityPoints = {[iGround1Points iGround2Points]',[iLeft1Points]',[iRight1Points]',[iLeft2Points]',[iRight2Points]'}';
entityChildEntities = {[]',[]',[]',[]',[]'}';

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
constraints(end+1,:) =  {[]',[]' ,[1 2]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 3]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 4]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[1 5]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[2 3]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[4 5]',[]','plane-plane-fixedAngle'        ,1}; 
constraints(end+1,:) =  {[]',[]' ,[2 4]',[]','plane-plane-fixedAngle'        ,0}; 
constraints(end+1,:) =  {[]',[]' ,[3 5]',[]','plane-plane-fixedAngle'        ,0}; 

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
