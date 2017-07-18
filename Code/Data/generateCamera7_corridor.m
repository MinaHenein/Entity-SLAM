function [camera] = generateCamera7_corridor(config)
%GENERATECAMERA_2 Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes
%   camera sensor points in z direction of camera

%% 1. Generate pose
length = 200;
cameraPose = zeros(config.dimPose,config.nSteps);
%constant linear velocity in x-axis direction, constant angular velocity about x-axis
cameraPose(1,:) = linspace(0,0,config.nSteps);
cameraPose(2,:) = linspace(0,length,config.nSteps);
cameraPose(3,:) = linspace(5,5,config.nSteps);
cameraPose(4,:) = linspace(-pi/2,-pi/2,config.nSteps);
cameraPose(5,:) = linspace(0,0,config.nSteps);
cameraPose(6,:) = linspace(0,0,config.nSteps);

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% 2. Create camera class instance
camera = Camera(config,cameraPose);

end

