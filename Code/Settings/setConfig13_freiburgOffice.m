function [obj] = setConfig13_freiburgOffice(obj)
%SETCONFIG1_TESTING Summary of this function goes here
%   Detailed explanation goes here

%   rng
obj.rngSeed = 2;
%   dimensions
obj.dimPose  = 6;
obj.dimPoint = 3;
%   factors
obj.poseParameterisation = 'R3xSO3';
obj.absoluteToRelativePoseHandle  = @AbsoluteToRelativePose;
obj.absoluteToRelativePointHandle = @AbsoluteToRelativePosition;
obj.relativeToAbsolutePoseHandle  = @RelativeToAbsolutePose;
obj.relativeToAbsolutePointHandle = @RelativeToAbsolutePosition;
%   data generating functions
obj.simulateData = 0;
obj.groundTruthFileName = 'GT_Vertices_GraphFile.graph';
obj.measurementsFileName = 'Measurement_Edges_GraphFile.graph';
%   camera settings
obj.cameraControlInput          = 'relativePose';
obj.cameraPointParameterisation = 'euclidean';
%   plane parameterisation
obj.planeNormalParameterisation = 'S2';
%   constraints
obj.applyAngleConstraints = 1;
obj.automaticAngleConstraints = 0;
%   covariances
obj.noiseSwitch    = 'on';
% obj.stdPosePrior   = [0.001,0.001,0.001,pi/600,pi/600,pi/600]';
% obj.stdPointPrior  = [0.001,0.001,0.001]';
% obj.stdPosePose    = [1,1,1,pi/72,pi/72,pi/72]';
% obj.stdPosePoint   = [0.05,0.05,0.05]';
% obj.stdPointPlane  = 0.001;
% obj.stdPlaneNormal = 0.001;
% obj.stdSurface     = 0.001;
% obj.stdPlanePlaneAngle    = pi/60;
% obj.stdPlanePlaneDistance = 0.01;
% obj.stdPlaneEstimate      = [0.1,0.1,0.1,0.1]';
%   first linearisation point
obj.startPose = 'initial';
obj.staticAssumption = 1;
%   solver settings
obj.sortVertices = 0;
obj.sortEdges = 0;
obj.processing = 'batch';
% obj.processing = 'incremental';
obj.nVerticesThreshold = inf;
obj.nEdgesThreshold    = inf;
obj.solveRate  = 25;
% obj.solverType = 'Gauss-Newton';
obj.solverType = 'Levenberg-Marquardt';
obj.threshold     = 10e-4;
obj.maxNormDX     = 1e10;
obj.maxIterations = 1000;
%   saving
obj.savePath = pwd;
%   plotting
obj.plotPlanes = 1;
obj.plotIncremental = 0;
%obj.plotView = [-20 45];
%obj.axisLimits = [200 300 -420 -320 0 60];
%obj.axisEqual = 1;
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

