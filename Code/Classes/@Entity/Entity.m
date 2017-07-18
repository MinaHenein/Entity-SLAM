classdef Entity
    %ENTITY Class represents an entity in environment
    %   properties:
    %       type - geomatric primitives ie line,plane,sphere etc
    %                  3 x nSteps, giving position at each time step.
    %       parameters - depend on type. ie plane, parameters = [n; d]
    %       iObjects - indexes of objects that entity belongs to with
    %       iParentEntities - indexes of entities that entity belongs to
    %       iChildEntities - indexes of entities that entity contains
    %       iPoints - indexes of points that entity contains
    %       iConstraints - indexes of constraints that entity is associated 
    %                      with
    %       index - entity index. Indexes are unique for entities
    %       nObjects - no. objects associated with point
    %       nParentEntities - no. parent entities
    %       nChildEntities - no. child entities
    %       nConstraints - no. constraints associated with point
    %       motion - ("static"/"dynamic"). 
    %       compound - (0/1) is entity composed of other entities
    
    properties
        type                
        parameters          
        iObjects
        iParentEntities
        iChildEntities
        iPoints  
        iConstraints
        index
    end
    
    properties (Dependent)
        motion
        compound
        nObjects
        nParentEntities
        nChildEntities
        nPoints
        nConstraints
    end
    
    methods
        %% constructor
        function obj = Entity(varargin)
            switch nargin
                case 0 %allow for preallocation of empty object array
                case 3 %initialise with type and parameters, index
                    obj.type = varargin{1};
                    obj.parameters = varargin{2};
                    obj.iObjects  = [];
                    obj.iParentEntities = [];
                    obj.iChildEntities  = [];
                    obj.iPoints   = [];
                    obj.index     = varargin{3};                  
            end
        end  
        
        %% get motion
        function motion = get.motion(obj)
            dParameters = bsxfun(@minus,obj.parameters,obj.parameters(:,1));
            if isempty(find(dParameters,1))
                motion = 'static';
            else
                motion = 'dynamic';
            end
        end
        
        %% get compound
        function compound = get.compound(obj)
            switch obj.type
                case 'plane'
                    compound = 0;
                case {'angle','distance'}
                    compound = 1;
                otherwise
                    error('%s entity type not implemented',obj.type)
            end
        end
        
        %% sizes
        function nPoints = get.nPoints(obj)
            nPoints = numel(obj.iPoints);
        end
        function nParentEntities = get.nParentEntities(obj)
            nParentEntities = numel(obj.iParentEntities);
        end
        function nChildEntities = get.nChildEntities(obj)
            nChildEntities = numel(obj.iChildEntities);
        end
        function nObjects = get.nObjects(obj)
            nObjects = numel(obj.iObjects);
        end
        function nConstraints = get.nConstraints(obj)
            nConstraints = numel(obj.iConstraints);
        end
        
    end
    
end

