function [camera] = generateCamera6_loadLoop(config)
%GENERATECAMERA_2 Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes
%   camera sensor points in z direction of camera

%% 1. Load poses
if ispc
    poseDataQuat = load(strcat(config.savePath,'\Data\PoseData\cityPose.txt'));
elseif isunix || ismac
    poseDataQuat = load(strcat(config.savePath,'/Data/PoseData/cityPose.txt'));
end

nPoses = size(poseDataQuat,1);
poseDataAxis = zeros(nPoses,7);
poseDataAxis(:,1:4) = poseDataQuat(:,1:4);
for i = 1:nPoses
    poseDataAxis(i,5:7) = q2a(poseDataQuat(i,[8 5:7]));
end

%% 2. Select poses
step = 10;
start = 800;
cameraPose = poseDataAxis(start:step:start+step*(config.nSteps-1),2:7)';
cameraPose(1:2,:) = bsxfun(@minus,cameraPose(1:2,:),cameraPose(1:2,1));

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% 3. Create camera class instance
camera = Camera(config,cameraPose);

%% 4. plot
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

