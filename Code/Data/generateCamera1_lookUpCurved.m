function [camera] = generateCamera1_lookUpCurved(config)
%GENERATECAMERA_0 Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes

%% 1. Generate pose
cameraPose = zeros(config.dimPose,config.nSteps);
%constant linear velocity in x-axis direction, constant angular velocity about x-axis
cameraPose(1,:) = 5*sin(linspace(0,pi/2,config.nSteps));
cameraPose(2,:) = 5 - 5*cos(linspace(0,pi/2,config.nSteps));
cameraPose(3,:) = linspace(0,2,config.nSteps);
cameraPose(4,:) = linspace(0,pi/4,config.nSteps);
cameraPose(5,:) = linspace(0,pi/8,config.nSteps);
cameraPose(6,:) = linspace(0,pi/6,config.nSteps);

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% 2. Create camera class instance
camera = Camera(config,cameraPose);

end

