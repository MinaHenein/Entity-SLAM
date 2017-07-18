classdef Constraint
    %CONSTRAINT represents constraint between features
    %   properties:
    %       type - ie point-plane, plane-plane-angle etc
    %       switchable - (0/1) determines if edge will be switchable
    %       value - depends on type. ie point-plane, if points ON plane,
    %               value is 0 (represents distance)
    %       iObjects - indexes of objects in constraint
    %       iEntities - indexes of entities in constraint
    %       iChildEntities - indexes of child entities in constraint
    %       iPoints - indexes of points in constraint
    %       index - constraint index. Indexes are unique for constraints
    
    properties
        type
        switchable
        value
        iObjects
        iEntities
        iChildEntities
        iPoints
        index       
    end
    
    methods
        %% constructor
        function obj = Constraint(varargin)
            switch nargin
                case 0 %allow for preallocation of empty object array
                case 7 %initialise with type and parameters
                    obj.type           = varargin{1};
                    obj.value          = varargin{2};
                    obj.iObjects       = varargin{3};
                    obj.iEntities      = varargin{4};
                    obj.iChildEntities = varargin{5};
                    obj.iPoints        = varargin{6};
                    obj.index          = varargin{7};
                    
            end
        end  

    end
    
end

