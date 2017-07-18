classdef Object
    %OBJECT Class represents an object in environment
    %   properties:
    %       pose - pose of object centre in absolute coordinates.
    %              orientation expressed as scaled axis
    %       type - ie cube, rectangle etc
    %       parameters - depend on type, ie cube, parameters = [sideLength]
    %       iEntities - indexes of entities that object contains
    %       iPoints - indexes of points that object contains
    %       iConstraints - indexes of constraints that object is associated 
    %                      with
    %       index - object index. Indexes are unique for objects
    %       nEntities - no. entities 
    %       nConstraints - no. constraints associated with point
    %       motion - ("static"/"dynamic"). 
    
    properties
        pose %object pose in absolute coordinates
        type
        parameters        
        iEntities    %indexes of entities it contains
        iPoints      %indexes of points it contains
        iConstraints
        index      %index of this object
    end
    
    properties (Dependent)
        nEntities
        nPoints
        nConstraints
        motion
    end
    
    methods
        %% constructor
        function obj = Object(varargin) %(poseAbsolute,entities)
            switch nargin
                case 0 %allow for preallocation of empty object array
                case 4 %initialise with pose, type, parameters, index
                    obj.pose = varargin{1};
                    obj.type = varargin{2};
                    obj.parameters = varargin{3};
                    obj.iEntities = []; 
                    obj.iPoints = [];   
                    obj.index = varargin{4};
            end
        end
        
        %% get motion
        function motion = get.motion(obj)
            dPose = bsxfun(@minus,obj.pose,obj.pose(:,1));
            if isempty(find(dPose,1))
                motion = 'static';
            else
                motion = 'dynamic';
            end
        end
        
        %% sizes
        function nPoints = get.nPoints(obj)
            nPoints = numel(obj.iPoints);
        end
        function nEntities = get.nEntities(obj)
            nEntities = numel(obj.iEntities);
        end
        function nConstraints = get.nConstraints(obj)
            nConstraints = numel(obj.iConstraints);
        end
        
    end
    
end

