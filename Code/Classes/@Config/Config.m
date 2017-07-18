classdef Config
    %CONFIG Stores simulation settings
    %   default settings are provided by function setConfig0_default.
    %   Additional settings are chosen by another setConfig function,
    %   chosen by an input passed to the class constructor.
    
    properties
        %   0-random number seed unfixed, >0-fixed to this seed
        rngSeed
        %   dimensions
        dimPose
        dimPoint
        % scale
        scale
        % number of loops
        nLoops
        %   time
        nSteps
        dt
        %   factors
        poseParameterisation
        absoluteToRelativePoseHandle
        absoluteToRelativePointHandle
        relativeToAbsolutePoseHandle
        relativeToAbsolutePointHandle
        %   data generating functions
        simulateData
        groundTruthFileName
        measurementsFileName
        cameraHandle
        mapHandle   
        %   camera settings
        cameraControlInput
        cameraPointParameterisation
        cameraFieldOfView
        cameraMaxRange
        %   plane parameterisation
        planeNormalParameterisation
        %   constraints
        applyAngleConstraints
        automaticAngleConstraints
        %   noise
        noiseSwitch
        stdPosePrior
        stdPointPrior
        stdPosePose
        stdPosePoint
        stdPointPlane
        stdPlaneNormal
        stdSurface
        stdPlanePlaneAngle
        stdPlanePlaneDistance
        stdPlaneEstimate 
        %   first linearisation point
        startPose
        %   single/multiple vertices for static features
        staticAssumption
        %   solver settings
        sortVertices
        sortEdges
        processing
        nVerticesThreshold
        nEdgesThreshold
        solveRate
        maxPoses
        solverType
        threshold
        maxNormDX
        maxIterations
        %   saving
        savePath
        %   plotting  
        plotPlanes
        plotIncremental
        plotView
        axisLimits
        axisEqual
        %   display
        displayProgress
        displaySPPARMS
        %   timing
        timingFlag
        %   graph file labelling
        labelPoseVertex
        labelPointVertex
        labelPointRGBVertex
        labelPlaneVertex
        labelAngleVertex
        labelDistanceVertex
        labelPosePriorEdge
        labelPosePoseEdge
        labelPosePointEdge
        labelPointPointRGBEdge
        labelPointPlaneEdge
        labelAngleEdge
        labelDistanceEdge
        labelFixedAngleEdge
        labelFixedDistanceEdge
        labelPlanePriorEdge
    end
    
    properties (Dependent)
        %covariances
        covPosePrior
        covPointPrior
        covSwitchPrior
        covPosePose
        covPosePoint
        covPointPlane
        covPlaneNormal
        covSurface
        covPlanePlaneAngle
        covPlanePlaneDistance
        covPlaneEstimate
    end
    
    methods
        %% constructor
        function obj = Config(settings)
            %assign default parameters, below is additional settings
            obj = setConfig0_default(obj);
            switch settings                    
                case 'batchTesting'
                    obj = setConfig1_testing(obj);
                case 'montecarlo'
                    obj = setConfig2_montecarlo(obj);
                case 'incrementalTesting'
                    obj = setConfig3_incremental(obj);
                case 'small'
                    obj = setConfig4_small(obj);
                case 'citySmall'
                    obj = setConfig5_citySmall(obj);
                case 'city'
                    obj = setConfig6_city(obj);
                case 'smallLoop'
                    obj = setConfig7_smallLoop(obj);
                case 'corridor'
                    obj = setConfig8_corridor(obj);
                case 'realsense'
                    obj = setConfig9_realsense(obj);
                case 'largeLoop'
                    obj = setConfig10_largeLoop(obj);
                case 'angularConstraintsTesting'
                    obj = setConfig11_angularConstraintsTesting(obj);
                case 'cube'
                    obj = setConfig12_cube(obj);
                case 'FreiburgOffice'
                    obj = setConfig13_freiburgOffice(obj);
                otherwise
                    error('Config for %s not yet defined',settings)
            end
        end
        
        %% get
        %covariances
        function covPosePrior = get.covPosePrior(obj)
            covPosePrior = stdToCovariance(obj.stdPosePrior);
        end
        function covPointPrior = get.covPointPrior(obj)
            covPointPrior = stdToCovariance(obj.stdPointPrior);
        end
        function covSwitchPrior = get.covSwitchPrior(obj)
            covSwitchPrior = stdToCovariance(obj.stdSwitchPrior);
        end
        function covPosePose = get.covPosePose(obj)
            covPosePose = stdToCovariance(obj.stdPosePose);
        end
        function covPosePoint = get.covPosePoint(obj)
            covPosePoint = stdToCovariance(obj.stdPosePoint);
        end
        function covPointPlane = get.covPointPlane(obj)
            covPointPlane = stdToCovariance(obj.stdPointPlane);
        end
        function covPlaneNormal = get.covPlaneNormal(obj)
            covPlaneNormal = stdToCovariance(obj.stdPlaneNormal);
        end
        function covSurface = get.covSurface(obj)
            covSurface = stdToCovariance(obj.stdSurface);
        end
        function covPlanePlaneAngle = get.covPlanePlaneAngle(obj)
            covPlanePlaneAngle = stdToCovariance(obj.stdPlanePlaneAngle);
        end
        function covPlanePlaneDistance = get.covPlanePlaneDistance(obj)
            covPlanePlaneDistance = stdToCovariance(obj.stdPlanePlaneDistance);
        end
        function covPlaneEstimate = get.covPlaneEstimate(obj)
            covPlaneEstimate = stdToCovariance(obj.stdPlaneEstimate);
        end
    end
    
end
