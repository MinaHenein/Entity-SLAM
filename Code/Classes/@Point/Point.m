classdef Point
    %POINT Class represents a point in environment
    %   properties:
    %       position - position in absolute coordinates. position has size
    %                  3 x nSteps, giving position at each time step.
    %       iObjects - indexes of objects that point belongs to
    %       iEntities - indexes of entities that point belongs to
    %       iConstraints - indexes of constraints that point is associated 
    %                      with
    %       index - point index. Indexes are unique feature types.
    %       nObjects - no. objects associated with point
    %       nEntities - no. entities associated with point
    %       nConstraints - no. constraints associated with point
    %       motion - ("static"/"dynamic"). 
    
    properties
        position %test
        iObjects
        iEntities
        iConstraints
        index
    end
    
    properties (Dependent)
        nObjects
        nEntities
        nConstraints
        motion
    end
    
    
    methods
        %% contructor
        function obj = Point(varargin)
            switch nargin
                case 0 %allows preallocation of empty point array
                case 2 %position, index
                    obj.position  = varargin{1};
                    obj.iObjects  = [];
                    obj.iEntities = [];
                    obj.index     = varargin{2};                   
            end
        end
        
        %% get motion
        function motion = get.motion(obj)
            dPosition = bsxfun(@minus,obj.position,obj.position(:,1));
            if isempty(find(dPosition,1))
                motion = 'static';
            else
                motion = 'dynamic';
            end
        end
        
        %% sizes
        function nEntities = get.nEntities(obj)
            nEntities = numel(obj.iEntities);
        end
        function nObjects = get.nObjects(obj)
            nObjects = numel(obj.iObjects);
        end
        function nConstraints = get.nConstraints(obj)
            nConstraints = numel(obj.iConstraints);
        end
    end
    
end

