function [obj] = setConfig5_citySmall(obj)
%SETCONFIG1_TESTING Summary of this function goes here
%   Detailed explanation goes here

%   rng
obj.rngSeed = 2;
%   dimensions
obj.dimPose  = 6;
obj.dimPoint = 3;
%   time
% obj.nSteps = 20;
% obj.dt     = 1;
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
obj.simulateData = 0;
obj.groundTruthFileName = 'GT_Vertices_GraphFile_small.graph';
obj.measurementsFileName = 'Measurement_Edges_GraphFile_small.graph';
% obj.cameraHandle = @generateCamera1;
% obj.mapHandle    = @generateMap3_constrainedPlanes; 
%   camera settings
obj.cameraControlInput          = 'relativePose';
obj.cameraPointParameterisation = 'euclidean';
obj.cameraFieldOfView           = [-pi/3 pi/3 -pi/6 pi/6]; %min/max bearing & elevation angles
obj.cameraMaxRange              = 5; %5m
%   plane parameterisation
obj.planeNormalParameterisation = 'S2';
%   constraints
obj.applyAngleConstraints = 1;
obj.automaticAngleConstraints = 0;
%   covariances
obj.noiseSwitch    = 'on';
obj.stdPosePrior   = [0.001,0.001,0.001,pi/600,pi/600,pi/600]';
obj.stdPointPrior  = [0.001,0.001,0.001]';
obj.stdPosePose    = [1,1,1,pi/72,pi/72,pi/72]';
obj.stdPosePoint   = [0.05,0.05,0.05]';
obj.stdPointPlane  = 0.001;
obj.stdPlaneNormal = 0.001;
obj.stdSurface     = 0.001;
obj.stdPlanePlaneAngle    = pi/60;
obj.stdPlanePlaneDistance = 0.01;
obj.stdPlaneEstimate      = [0.1,0.1,0.1,0.1]';
%   first linearisation point
% obj.startPose = 'initial';
obj.startPose = 'middle';
%   single/multiple vertices for static features
obj.staticAssumption = 1;
%   solver settings
obj.sortVertices = 0;
obj.sortEdges = 0;
obj.processing = 'batch';
% obj.processing = 'incremental';
obj.nVerticesThreshold = 100;
obj.nEdgesThreshold    = 200;
obj.solveRate  = 5;
obj.solverType = 'Gauss-Newton';
% obj.solverType = 'Levenberg-Marquardt';
obj.threshold     = 10e-4;
obj.maxNormDX     = 1e10;
obj.maxIterations = 100;
%   saving
obj.savePath = pwd;
%   plotting
obj.plotPlanes = 1;
obj.plotIncremental = 0;
obj.plotView = [-20 45];
obj.axisLimits = [-5 5 -10 50 -5 20];
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

