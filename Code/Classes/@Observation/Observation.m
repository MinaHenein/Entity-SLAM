classdef Observation
    %OBSERVATION Class represents observations of odometry, points,
    %entities, objects and constraints.
    %   Properties:
    %       time - time observation was made
    %       value - if direct measurement made, stored here
    %       covariance - covariance of observation
    %       type - type of observation, ie pose-pose, pose-point etc
    %       switchable - should edge that is built from this observation be
    %                    switchable. (0/1)
    %       iPoses - indexes of poses involved. Indexing unique to each
    %                type only.
    %       iPoints - indexes of points involved
    %       iEntities - indexes of entities involved
    %       iChildEntities - observation containts entities and child
    %                        entities, store child entity indexes here
    %       iObjects - indexes of objects involved
    %       iConstraints - indexes of constraints involved
    %       index - index of measurement
    
    properties
        time
        value
        covariance        
        type
        switchable
        newFeature
        iPoses
        iPoints
        iEntities
        iChildEntities
        iObjects
        iConstraints
        index        
    end
    
    methods
        %% constructor
        function obj = Observation(varargin)
            switch nargin
                case 0 %preallocation
                case 13
                    obj.time           = varargin{1};
                    obj.value          = varargin{2};
                    obj.covariance     = varargin{3};
                    obj.type           = varargin{4};
                    obj.switchable     = varargin{5};
                    obj.newFeature     = varargin{6};
                    obj.iPoses         = varargin{7};
                    obj.iPoints        = varargin{8};
                    obj.iEntities      = varargin{9};
                    obj.iChildEntities = varargin{10};
                    obj.iObjects       = varargin{11};
                    obj.iConstraints   = varargin{12};
                    obj.index          = varargin{13};
            end
        end
    end
    
end

