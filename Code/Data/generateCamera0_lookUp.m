function [camera] = generateCamera0_lookUp(config)
%GENERATECAMERA_0 Generates camera class instance from config
%   pose: constant linear and angular velocity about x axis

%% 1. Generate pose
cameraPose = zeros(config.dimPose,config.nSteps);
%constant linear velocity in x-axis direction, constant angular velocity about x-axis
cameraPose(1,:) = linspace(0,5,config.nSteps);
cameraPose(3,:) = linspace(0,0,config.nSteps);
cameraPose(4,:) = linspace(0-pi/4,-pi/4,config.nSteps);
cameraPose(5,:) = linspace(0,0,config.nSteps);
% cameraPose(6,:) = linspace(0,pi,config.nSteps);

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% 2. Create camera class instance
camera = Camera(config,cameraPose);

end

