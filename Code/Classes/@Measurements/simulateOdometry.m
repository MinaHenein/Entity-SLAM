function [obj] = simulateOdometry(obj,config,camera,i)
%SIMULATEODOMETRY simulates odometry measurements.
%   Takes ground truth poses from camera, computes relative pose, converts
%   to desired camera parameterisation and adds gaussian noise.
%   Odometry measurement made at time i is odometry between camera at
%   time i-1 and camera at time i

%% 1. properties
time = config.dt*i;
pose1 = camera.pose(:,i-1);
pose2 = camera.pose(:,i);
switch camera.controlInput
    case 'relativePose'
        relativePose = config.absoluteToRelativePoseHandle(pose1,pose2);
        value = relativePose;
    case 'bodyFixedVelocity'
        bodyFixedVelocity = config.absoluteToRelativePoseHandle(pose1,pose2)/config.dt;
        value = bodyFixedVelocity;
    otherwise
        error('%s control input not yet implemented',camera.controlInput)
end
covariance = config.covPosePose;
type       = 'odometry';
switchable = 0;
newFeature = 1;
iPoses     = [i-1,i]';
iPoints    = [];
iEntities  = [];
iChildEntities = [];
iObjects       = [];
iConstraints   = [];
% index = observationCount;
index = length([obj.observations.index])+1;

%% 2. construct observation
obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);
                                             
%% 3. store index
obj.iOdometryObservations = [obj.iOdometryObservations; index];
                                             
end

