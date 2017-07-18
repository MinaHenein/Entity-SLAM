classdef Camera
    %CAMERA Class used to reprent a camera sensor
    %   properties:
    %       pose - 6 x nSteps array, each column is so3 element.
    %              rotation in scaled axis representation
    %       controlInput - from config.cameraControlInput. Determines if
    %                      odometry will give relativePose or body fixed
    %                      velocity
    %       fieldOfView - from config.cameraFieldOfView. Min and max range
    %                     and bearing angles visible to camera
    %       pointParameterisation - config.cameraPointParameterisation. 
    %                               Determines form of point observations.
    %                               ie relative position, inverse depth etc
    
    properties
        pose
        controlInput
        fieldOfView
        pointParameterisation
        maxRange
    end
    
    properties (Dependent)
        nPoses
    end
    
    methods
        %% Constructor
        function obj = Camera(config,pose)
            obj.pose = pose;
            obj.controlInput = config.cameraControlInput;
            obj.pointParameterisation = config.cameraPointParameterisation;
            obj.fieldOfView = config.cameraFieldOfView;  
            obj.maxRange = config.cameraMaxRange;
        end
        
        %% get nPoses
        function nPoses = get.nPoses(obj)
            nPoses = size(obj.pose,2);
        end
        
    end
    
end

