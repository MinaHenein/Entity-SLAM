function [camera] = generateCamera10_largeLoop(config)
%GENERATECAMERA10_LARGELOOP Generates camera class instance from config
%   pose: linear and angular velocity about x,y,z axes
%   camera sensor points in z direction of camera

%% 1. Generate pose
nSteps = config.nSteps;
nLoops = config.nLoops;
scale  = config.scale;
cameraPose = zeros(config.dimPose,nSteps);

if config.nLoops > 1
    nSides = 9*config.nLoops;
else
    nSides = 9;
end

nSidePosesRatio = [20,40,30,30,20,90,60,20,20];
nSidePosesRatio = repmat(nSidePosesRatio,1,nLoops);
nPoses = sum(nSidePosesRatio);

nSidePoses = zeros(nSides,1);
for i =1:nSides
    nSidePoses(i,1) = nSteps*nSidePosesRatio(i)/nPoses;
end
sidePosesEnd = cumsum(nSidePoses);

%side 1
camHeight = 20;
iPosesSide1 = 1:sidePosesEnd(1);
cameraPose(1,iPosesSide1) = linspace(10*scale,10*scale,nSidePoses(1));
cameraPose(2,iPosesSide1) = linspace(5*scale,35*scale,nSidePoses(1));
cameraPose(3,iPosesSide1) = linspace(camHeight,camHeight,nSidePoses(1));
cameraPose(4,iPosesSide1) = linspace(-pi/2,-pi/2,nSidePoses(1));
cameraPose(5,iPosesSide1) = linspace(0,0,nSidePoses(1));
cameraPose(6,iPosesSide1) = linspace(0,0,nSidePoses(1));

%side 2 
iPosesSide2 = sidePosesEnd(1)+1:sidePosesEnd(2);
cameraPose(1,iPosesSide2) = linspace(8*scale,-40*scale,nSidePoses(2));
cameraPose(2,iPosesSide2) = linspace(35*scale,35*scale,nSidePoses(2));
cameraPose(3,iPosesSide2) = linspace(camHeight,camHeight,nSidePoses(2));
cameraPose(4,iPosesSide2) = linspace(0,0,nSidePoses(2));
cameraPose(5,iPosesSide2) = linspace(-pi/2,-pi/2,nSidePoses(2));
cameraPose(6,iPosesSide2) = linspace(0,0,nSidePoses(2));
 
%side 3 
iPosesSide3 = sidePosesEnd(2)+1:sidePosesEnd(3);
cameraPose(1,iPosesSide3) = linspace(-40*scale,-40*scale,nSidePoses(3));
cameraPose(2,iPosesSide3) = linspace(38*scale,105*scale,nSidePoses(3));
cameraPose(3,iPosesSide3) = linspace(camHeight,camHeight,nSidePoses(3));
cameraPose(4,iPosesSide3) = linspace(-pi/2,-pi/2,nSidePoses(3));
cameraPose(5,iPosesSide3) = linspace(0,0,nSidePoses(3));
cameraPose(6,iPosesSide3) = linspace(0,0,nSidePoses(3));

%side 4 
iPosesSide4 = sidePosesEnd(3)+1:sidePosesEnd(4);
cameraPose(1,iPosesSide4) = linspace(-42*scale,-90*scale,nSidePoses(4));
cameraPose(2,iPosesSide4) = linspace(105*scale,105*scale,nSidePoses(4));
cameraPose(3,iPosesSide4) = linspace(camHeight,camHeight,nSidePoses(4));
cameraPose(4,iPosesSide4) = linspace(0,0,nSidePoses(4));
cameraPose(5,iPosesSide4) = linspace(-pi/2,-pi/2,nSidePoses(4));
cameraPose(6,iPosesSide4) = linspace(0,0,nSidePoses(4));

%side 5 
iPosesSide5 = sidePosesEnd(4)+1:sidePosesEnd(5);
cameraPose(1,iPosesSide5) = linspace(-90*scale,-90*scale,nSidePoses(5));
cameraPose(2,iPosesSide5) = linspace(107*scale,135*scale,nSidePoses(5));
cameraPose(3,iPosesSide5) = linspace(camHeight,camHeight,nSidePoses(5));
cameraPose(4,iPosesSide5) = linspace(-pi/2,-pi/2,nSidePoses(5));
cameraPose(5,iPosesSide5) = linspace(0,0,nSidePoses(5));
cameraPose(6,iPosesSide5) = linspace(0,0,nSidePoses(5));

%side 6 
iPosesSide6 = sidePosesEnd(5)+1:sidePosesEnd(6);
cameraPose(1,iPosesSide6) = linspace(-88*scale,45*scale,nSidePoses(6));
cameraPose(2,iPosesSide6) = linspace(135*scale,135*scale,nSidePoses(6));
cameraPose(3,iPosesSide6) = linspace(camHeight,camHeight,nSidePoses(6));
cameraPose(4,iPosesSide6) = linspace(0,0,nSidePoses(6));
cameraPose(5,iPosesSide6) = linspace(pi/2,pi/2,nSidePoses(6));
cameraPose(6,iPosesSide6) = linspace(0,0,nSidePoses(6));

%side 7 
iPosesSide7 = sidePosesEnd(6)+1:sidePosesEnd(7);
cameraPose(1,iPosesSide7) = linspace(45*scale,45*scale,nSidePoses(7));
cameraPose(2,iPosesSide7) = linspace(134*scale,35*scale,nSidePoses(7));
cameraPose(3,iPosesSide7) = linspace(camHeight,camHeight,nSidePoses(7));
cameraPose(4,iPosesSide7) = linspace(pi/2,pi/2,nSidePoses(7));
cameraPose(5,iPosesSide7) = linspace(0,0,nSidePoses(7));
cameraPose(6,iPosesSide7) = linspace(0,0,nSidePoses(7));

%side 8 
iPosesSide8 = sidePosesEnd(7)+1:sidePosesEnd(8);
cameraPose(1,iPosesSide8) = linspace(43*scale,8*scale,nSidePoses(8));
cameraPose(2,iPosesSide8) = linspace(35*scale,35*scale,nSidePoses(8));
cameraPose(3,iPosesSide8) = linspace(camHeight,camHeight,nSidePoses(8));
cameraPose(4,iPosesSide8) = linspace(0,0,nSidePoses(8));
cameraPose(5,iPosesSide8) = linspace(-pi/2,-pi/2,nSidePoses(8));
cameraPose(6,iPosesSide8) = linspace(0,0,nSidePoses(8));

%side 9 [side1 reversed direction to close loop] 
iPosesSide9 = sidePosesEnd(8)+1:sidePosesEnd(9);
cameraPose(1,iPosesSide9) = linspace(10*scale,10*scale,nSidePoses(9));
cameraPose(2,iPosesSide9) = linspace(35*scale,5*scale,nSidePoses(9));
cameraPose(3,iPosesSide9) = linspace(camHeight,camHeight,nSidePoses(9));
cameraPose(4,iPosesSide9) = linspace(pi/2,pi/2,nSidePoses(9));
cameraPose(5,iPosesSide9) = linspace(0,0,nSidePoses(9));
cameraPose(6,iPosesSide9) = linspace(0,0,nSidePoses(9));

if nLoops > 1
nSidesPerLoop = nSides/nLoops;
for i=nSidesPerLoop+1:nSidesPerLoop*nLoops
    iPosesSide = sidePosesEnd(i-1)+1:sidePosesEnd(i);
    if mod(i,nSidesPerLoop) == 0
        a =  sidePosesEnd(nSidesPerLoop-1)+1:sidePosesEnd(nSidesPerLoop);
    elseif mod(i,nSidesPerLoop) == 1
        a = 1:sidePosesEnd(mod(i,nSidesPerLoop));
    else
        a = sidePosesEnd(mod(i,nSidesPerLoop)-1)+1:sidePosesEnd(mod(i,nSidesPerLoop));
    end
    cameraPose(1,iPosesSide) = cameraPose(1,a);
    cameraPose(2,iPosesSide) = cameraPose(2,a);
    cameraPose(3,iPosesSide) = cameraPose(3,a);
    cameraPose(4,iPosesSide) = cameraPose(4,a);
    cameraPose(5,iPosesSide) = cameraPose(5,a);
    cameraPose(6,iPosesSide) = cameraPose(6,a);
end

end

%adjust based on parameterisation
if strcmp(config.poseParameterisation,'SE3')
    for i = 1:nSteps
        cameraPose(:,i) = R3xso3_LogSE3(cameraPose(:,i));
    end
end

% create camera class instance
camera = Camera(config,cameraPose);

% figure
% axis equal
% view(-19,43)
% xlabel('x')
% ylabel('y')
% zlabel('z')
% hold on
% for i = 1:nSteps
%     iPose = cameraPose(:,i);
%     plotiCamera = plotCamera('Location',iPose(1:3),'Orientation',rot(-iPose(4:6))); %LHS invert pose
%     plotiCamera.Opacity = 0.1;
%     plotiCamera.Size = 0.5;
%     plotiCamera.Color = [0 0 1];
%     plotiCamera.AxesVisible = 1;
% end

end

