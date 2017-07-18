function [obj] = setConfig7_smallLoop(obj)
%SETCONFIG1_TESTING Summary of this function goes here
%   Detailed explanation goes here

%   rng
% obj.rngSeed = 2;
obj.rngSeed = 4;
%   dimensions
obj.dimPose  = 6;
obj.dimPoint = 3;
%   time
obj.nSteps = 100;
obj.dt     = 1;
%   factors
obj.poseParameterisation = 'R3xSO3';
obj.absoluteToRelativePoseHandle  = @AbsoluteToRelativePose;
obj.absoluteToRelativePointHandle = @AbsoluteToRelativePosition;
obj.relativeToAbsolutePoseHandle  = @RelativeToAbsolutePose;
obj.relativeToAbsolutePointHandle = @RelativeToAbsolutePosition;
% obj.poseParameterisation = 'SE3';
% obj.absoluteToRelativePoseHandle  = @Absolute2RelativeSE3;
% obj.absoluteToRelativePointHandle = @AbsolutePoint2RelativePoint3D;
% obj.relativeToAbsolutePoseHandle  = @Relative2AbsoluteSE3;
% obj.relativeToAbsolutePointHandle = @RelativePoint2AbsolutePoint3D;
%   data generating functions
obj.simulateData = 1;
obj.groundTruthFileName = 'groundTruth.graph';
obj.measurementsFileName = 'measurements.graph';
% obj.cameraHandle = @generateCamera0_lookUp;
% obj.cameraHandle = @generateCamera1_lookUpCurved;
% obj.cameraHandle = @generateCamera2_smallCity;
% obj.cameraHandle = @generateCamera3_smallCity2;
% obj.cameraHandle = @generateCamera4_longerStreet;
% obj.cameraHandle = @generateCamera5_squareLoop;
obj.cameraHandle = @generateCamera6_loadLoop;
% obj.cameraHandle = @generateCamera7_corridor;
% obj.mapHandle    = @generateMap0_full; 
% obj.mapHandle    = @generateMap1_points; 
% obj.mapHandle    = @generateMap2_planes; 
% obj.mapHandle    = @generateMap3_constrainedPlanes; 
% obj.mapHandle    = @generateMap4_switchable; 
% obj.mapHandle    = @generateMap5_plane; 
% obj.mapHandle    = @generateMap6_angle;
% obj.mapHandle    = @generateMap7_randomPlane;
% obj.mapHandle    = @generateMap8_smallCity;
% obj.mapHandle    = @generateMap10_longerStreet;
obj.mapHandle    = @generateMap11_loop;
% obj.mapHandle    = @generateMap12_corridor;
%   camera settings
obj.cameraControlInput          = 'relativePose';
obj.cameraPointParameterisation = 'euclidean';
obj.cameraFieldOfView           = [-pi/3 pi/3 -pi/6 pi/6]; %min/max bearing & elevation angles
obj.cameraMaxRange              = 20; %in metres
%   plane parameterisation
obj.planeNormalParameterisation = 'S2';
%   constraints
obj.applyAngleConstraints = 1;
obj.automaticAngleConstraints = 0;
%   covariances
obj.noiseSwitch    = 'on';
obj.stdPosePrior   = [0.001,0.001,0.001,pi/600,pi/600,pi/600]';
obj.stdPointPrior  = [0.001,0.001,0.001]';
obj.stdPosePose    = 10*[0.01,0.01,0.01,pi/90,pi/90,pi/90]';
obj.stdPosePoint   = 10*[0.08,0.08,0.08]';
obj.stdPointPlane  = 1;
obj.stdSurface     = 1;
obj.stdPlaneNormal = 0.001;
obj.stdPlanePlaneAngle    = pi/45;
obj.stdPlanePlaneDistance = 0.01;
obj.stdPlaneEstimate      = [0.1,0.1,0.1,0.1]';
%   first linearisation point
% obj.startPose = 'initial';
obj.startPose = 'middle';
%   single/multiple vertices for static features
obj.staticAssumption = 1;
%   solver settings
obj.sortVertices = 1;
obj.sortEdges = 1;
% obj.processing = 'batch';
obj.processing = 'incremental';
obj.nVerticesThreshold = 10;
obj.nEdgesThreshold    = 100;
obj.solveRate  = 5;
% obj.solverType = 'Gauss-Newton';
obj.solverType = 'Levenberg-Marquardt';
% obj.solverType = 'Levenberg-Marquardt-testing';
% obj.solverType = 'Levenberg-Marquardt-g2o';
% obj.solverType = 'Levenberg-Marquardt-C';
% obj.solverType = 'Levenberg-Marquardt-C2';
obj.threshold     = 1e-3;
obj.maxNormDX     = 1e10;
obj.maxIterations = 25;
%   saving
obj.savePath = pwd;
%   plotting
obj.plotPlanes = 1;
obj.plotIncremental = 1;
obj.plotView = [-20 45];
obj.axisLimits = [-70 10 -10 75 -5 20];
obj.axisEqual = 1;
%   display progress
obj.displayProgress = 1;
obj.displaySPPARMS = 0;
%   timing
obj.timingFlag = 0;
%   graph file labelling
obj.labelPoseVertex        = 'VERTEX_POSE_LOG_SE3';
obj.labelPointVertex       = 'VERTEX_POINT_3D';
obj.labelPointRGBVertex    = 'VERTEX_POINT_3DRGB';
obj.labelPlaneVertex       = 'VERTEX_PLANE_4D';
obj.labelAngleVertex       = 'VERTEX_ANGLE_1D';
obj.labelDistanceVertex    = 'VERTEX_DISTANCE_1D';
obj.labelPosePriorEdge     = 'EDGE_6D';
obj.labelPosePoseEdge      = 'EDGE_LOG_SE3';
obj.labelPosePointEdge     = 'EDGE_3D';
obj.labelPointPointRGBEdge = 'EDGE_3DRGB';
obj.labelPointPlaneEdge    = 'EDGE_1D';
obj.labelAngleEdge         = 'HYPEREDGE_COS_RAD';
obj.labelDistanceEdge      = 'HYPEREDGE_R';
obj.labelFixedAngleEdge    = 'EDGE_COS_RAD';
obj.labelFixedDistanceEdge = 'EDGE_R';
obj.labelPlanePriorEdge    = 'EDGE_R3';

end

