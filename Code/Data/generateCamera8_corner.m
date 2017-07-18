function [camera] = generateCamera8_corner(config)
%GENERATECAMERA_2 Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes
%   camera sensor points in z direction of camera

%% 1. Generate pose
cameraPose = zeros(config.dimPose,config.nSteps);

assert(mod(config.nSteps,2) == 0)
nSidePoses = config.nSteps/2;
iPosesSide1 = [1:nSidePoses];
iPosesSide2 = [iPosesSide1(end)+1:iPosesSide1(end)+nSidePoses];

%side 1
cameraPose(1,iPosesSide1) = linspace(0,0,nSidePoses);
cameraPose(2,iPosesSide1) = linspace(0,100,nSidePoses);
cameraPose(3,iPosesSide1) = linspace(5,5,nSidePoses);
cameraPose(4,iPosesSide1) = linspace(-pi/2,-pi/2,nSidePoses);
cameraPose(5,iPosesSide1) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide1) = linspace(0,0,nSidePoses);

%side 2 
cameraPose(1,iPosesSide2) = linspace(0,100,nSidePoses);
cameraPose(2,iPosesSide2) = linspace(104,104,nSidePoses);
cameraPose(3,iPosesSide2) = linspace(5,5,nSidePoses);
r = [0 0 1; -1 0 0; 0 -1 0];
a = arot(r);
cameraPose(4:6,iPosesSide2) = repmat(a,1,nSidePoses);

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% create camera class instance
camera = Camera(config,cameraPose);

% figure
% axis equal
% view(-19,43)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold on
% for i = 1:config.nSteps
%     iPose = cameraPose(:,i);
%     plotiCamera = plotCamera('Location',iPose(1:3),'Orientation',rot(-iPose(4:6))); %LHS invert pose
%     plotiCamera.Opacity = 0.1;
%     plotiCamera.Size = 0.5;
%     plotiCamera.Color = [0 0 1];
% %     plotiCamera.AxesVisible = 1;
% end

end

