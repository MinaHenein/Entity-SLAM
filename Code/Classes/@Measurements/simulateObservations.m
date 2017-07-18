function [obj] = simulateObservations(obj,config,map,camera)
%SIMULATEOBSERVATIONS generates observations of features from map and
%camera, while building a representation of the structure of the map from
%these observations
%   Observations are made for each feature type at each time step, to more
%   readily facilitate incremental processing.
%   At each time step, Measurement Class methods simulate observations of
%   odometry, visible points/entities/objects/constraints
%   In addition to simulating observations, these functions build a
%   reconstruction of the structure of the environment by associating
%   measurements with previously observed features or creating new features
%   when necessary. Checking is done to ensure that all features were
%   observed.

%% 1. Visibility of features
[pointVisibility,entityVisibility,...
 objectVisibility,constraintVisibility] = visibility(map,config,camera);
obj.pointVisibility = pointVisibility;
obj.entityVisibility = entityVisibility;
obj.objectVisibility = objectVisibility;
obj.constraintVisibility = constraintVisibility;

%% 2. Number of observations
nObservations = (camera.nPoses - 1) + sum(pointVisibility(:))...
                + sum(entityVisibility(:)) + sum(objectVisibility(:))...
                + sum(constraintVisibility(:));
obj.observations = Observation();
obj.observations(nObservations,1) = Observation();

%% 3. Simulate observations in order
%reconstruct map from observations as they come in (order important)
obj.map = Map();
for i = 1:camera.nPoses
    %   3.1. odometry
    %   odometry measurement arriving at time i is between poses at time
    %   i-1 and time i
    if i > 1 %no odometry at initial camera position
        obj = obj.simulateOdometry(config,camera,i);
    end
    
    %   3.2. point observations
    if map.nPoints
        obj = obj.observePoints(config,map,camera,i);
    end
    
    %   3.3. entities observed from points & child entities
    if map.nEntities
        obj = obj.observeEntities(config,map,i);
    end
    
    %   3.4. objects observed from points & entities
    if map.nObjects
        obj = obj.observeObjects(config,map,i);
    end
    %   3.5. constraint observations
    if map.nConstraints
        obj = obj.observeConstraints(config,map,i);
    end
end

%add noise AFTER - need same sequencing over each measurement type
observationTypes = {obj.observations.type}';
%odometry observations
logicalOdometryObservations = strcmp(observationTypes,'odometry');
iOdometryObservations = find(logicalOdometryObservations);
nOdometryObservations = numel(iOdometryObservations);
odometryObservations = [obj.observations(logicalOdometryObservations).value];
if config.rngSeed > 0
    rng(config.rngSeed);
end
muOdometry = zeros(config.dimPose,1);
sigmaOdometry = config.stdPosePose;
odometryObservationsNoisy = addGaussianNoise(config,muOdometry,sigmaOdometry,odometryObservations,'pose');
for i = 1:nOdometryObservations
    obj.observations(iOdometryObservations(i)).value = odometryObservationsNoisy(:,i);
end
      
%point observations
logicalPointObservations = strcmp(observationTypes,'pose-point');
iPointObservations = find(logicalPointObservations);
nPointObservations = numel(iPointObservations);
pointObservations = [obj.observations(logicalPointObservations).value];
if config.rngSeed > 0
    rng(config.rngSeed);
end
muPoint = zeros(config.dimPoint,1);
sigmaPoint = config.stdPosePoint;
pointObservationsNoisy = addGaussianNoise(config,muPoint,sigmaPoint,pointObservations);
for i = 1:nPointObservations
    obj.observations(iPointObservations(i)).value = pointObservationsNoisy(:,i);
end

%point-plane observations - dont add noise
%plane-plane-fixedAngle observations - dont add noise

%% 4. check that all features identified in map reconstruction
assert(obj.map.nPoints==map.nPoints,'Error: did not observe all points')
assert(obj.map.nEntities==map.nEntities,'Error: did not observe all entities')
assert(obj.map.nObjects==map.nObjects,'Error: did not observe all objects')
assert(obj.map.nConstraints==map.nConstraints,'Error: did not observe all constraints')

end

