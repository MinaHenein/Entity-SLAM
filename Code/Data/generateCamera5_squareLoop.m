function [camera] = generateCamera5_squareLoop(config)
%GENERATECAMERA_2 Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes
%   camera sensor points in z direction of camera


%***UNFINISHED

%% 1. Generate pose
cameraPose = zeros(config.dimPose,config.nSteps);
assert(config.nSteps == 120)
nSidePoses = 20;
nCornerPoses = 5;
iPosesSide1 = [1:nSidePoses];
iPosesCorner1 = [iPosesSide1(end)+1:iPosesSide1(end)+nCornerPoses];
iPosesSide2 = [iPosesCorner1(end)+1:iPosesCorner1(end)+nSidePoses];
iPosesCorner2 = [iPosesSide2(end)+1:iPosesSide2(end)+nCornerPoses];
iPosesSide3 = [iPosesCorner2(end)+1:iPosesCorner2(end)+nSidePoses];
iPosesCorner3 = [iPosesSide3(end)+1:iPosesSide3(end)+nCornerPoses];
iPosesSide4 = [iPosesCorner3(end)+1:iPosesCorner3(end)+nSidePoses];
iPosesCorner4 = [iPosesSide4(end)+1:iPosesSide4(end)+nCornerPoses];
iPosesSide5 = [iPosesCorner4(end)+1:iPosesCorner4(end)+nSidePoses];

%side 1
cameraPose(1,iPosesSide1) = linspace(0,0,nSidePoses);
cameraPose(2,iPosesSide1) = linspace(0,40,nSidePoses);
cameraPose(3,iPosesSide1) = linspace(15,15,nSidePoses);
cameraPose(4,iPosesSide1) = linspace(-pi/2,-pi/2,nSidePoses);
cameraPose(5,iPosesSide1) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide1) = linspace(0,0,nSidePoses);
%corner 1
cameraPose(1,iPosesCorner1) = 10*cos(linspace(0,pi/2,nCornerPoses)) - 10;
cameraPose(2,iPosesCorner1) = 10*sin(linspace(0,pi/2,nCornerPoses)) + 40;
cameraPose(3,iPosesCorner1) = linspace(15,15,nCornerPoses);
cameraPose(4,iPosesCorner1) = linspace(0,0,nCornerPoses);
cameraPose(5,iPosesCorner1) = linspace(0,0,nCornerPoses);
cameraPose(6,iPosesCorner1) = linspace(0,0,nCornerPoses);
%side 2 *WRONG ORIENTATION
cameraPose(1,iPosesSide2) = linspace(-10,-50,nSidePoses);
cameraPose(2,iPosesSide2) = linspace(50,50,nSidePoses);
cameraPose(3,iPosesSide2) = linspace(15,15,nSidePoses);
cameraPose(4,iPosesSide2) = linspace(-2/3*pi,-2/3*pi,nSidePoses);
cameraPose(5,iPosesSide2) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide2) = linspace(2/3*pi,2/3*pi,nSidePoses);
%corner 2
cameraPose(1,iPosesCorner2) = 10*cos(linspace(pi/2,pi,nCornerPoses)) - 50;
cameraPose(2,iPosesCorner2) = 10*sin(linspace(pi/2,pi,nCornerPoses)) + 40;
cameraPose(3,iPosesCorner2) = linspace(15,15,nCornerPoses);
cameraPose(4,iPosesCorner2) = linspace(0,0,nCornerPoses);
cameraPose(5,iPosesCorner2) = linspace(0,0,nCornerPoses);
cameraPose(6,iPosesCorner2) = linspace(0,0,nCornerPoses);
%side 3 *WRONG ORIENTATION
cameraPose(1,iPosesSide3) = linspace(-60,-60,nSidePoses);
cameraPose(2,iPosesSide3) = linspace(40,0,nSidePoses);
cameraPose(3,iPosesSide3) = linspace(15,15,nSidePoses);
cameraPose(4,iPosesSide3) = linspace(pi/2,pi/2,nSidePoses);
cameraPose(5,iPosesSide3) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide3) = linspace(0,0,nSidePoses);
%corner 3
cameraPose(1,iPosesCorner3) = 10*cos(linspace(pi,3/2*pi,nCornerPoses)) - 50;
cameraPose(2,iPosesCorner3) = 10*sin(linspace(pi,3/2*pi,nCornerPoses));
cameraPose(3,iPosesCorner3) = linspace(15,15,nCornerPoses);
cameraPose(4,iPosesCorner3) = linspace(0,0,nCornerPoses);
cameraPose(5,iPosesCorner3) = linspace(0,0,nCornerPoses);
cameraPose(6,iPosesCorner3) = linspace(0,0,nCornerPoses);
%side 4 *WRONG ORIENTATION
cameraPose(1,iPosesSide4) = linspace(-50,-10,nSidePoses);
cameraPose(2,iPosesSide4) = linspace(-10,-10,nSidePoses);
cameraPose(3,iPosesSide4) = linspace(15,15,nSidePoses);
cameraPose(4,iPosesSide4) = linspace(2/3*pi,2/3*pi,nSidePoses);
cameraPose(5,iPosesSide4) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide4) = linspace(2/3*pi,2/3*pi,nSidePoses);
%corner 4
cameraPose(1,iPosesCorner4) = 10*cos(linspace(3/2*pi,2*pi,nCornerPoses)) - 10;
cameraPose(2,iPosesCorner4) = 10*sin(linspace(3/2*pi,2*pi,nCornerPoses));
cameraPose(3,iPosesCorner4) = linspace(15,15,nCornerPoses);
cameraPose(4,iPosesCorner4) = linspace(0,0,nCornerPoses);
cameraPose(5,iPosesCorner4) = linspace(0,0,nCornerPoses);
cameraPose(6,iPosesCorner4) = linspace(0,0,nCornerPoses);
%side 5
cameraPose(1,iPosesSide5) = linspace(1,1,nSidePoses);
cameraPose(2,iPosesSide5) = linspace(0,40,nSidePoses);
cameraPose(3,iPosesSide5) = linspace(15,15,nSidePoses);
cameraPose(4,iPosesSide5) = linspace(-pi/2,-pi/2,nSidePoses);
cameraPose(5,iPosesSide5) = linspace(0,0,nSidePoses);
cameraPose(6,iPosesSide5) = linspace(0,0,nSidePoses);

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:config.nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

%% 2. Create camera class instance
camera = Camera(config,cameraPose);
figure
axis equal
view(-19,43)
xlabel('x')
ylabel('y')
zlabel('z')
hold on
for i = 1:config.nSteps
    iPose = cameraPose(:,i);
    plotiCamera = plotCamera('Location',iPose(1:3),'Orientation',rot(-iPose(4:6))); %LHS invert pose
    plotiCamera.Opacity = 0.1;
    plotiCamera.Size = 0.5;
    plotiCamera.Color = [0 0 1];
%     plotiCamera.AxesVisible = 1;
end

axis([-5 5 20 25 12 18]) %side 1
axis([-20 -15 45 55 12 18]) %side 2
axis([-65 -55 20 25 12 18]) %side 3
axis([-20 -15 -15 -5 12 18]) %side 4
end

