classdef Map
    %MAP Class represents environment
    %   stores object arrays of features (points, entities, objects,
    %   constraints)
    
    properties
        points
        entities
        objects
        constraints
    end
    
    properties (Dependent)
        nPoints
        nEntities
        nObjects
        nConstraints
        motion
    end
    
    methods
        %% Constructor
        function obj = Map(varargin)
            %   initialise empty map
        end
        
        %% sizes
        function nPoints = get.nPoints(obj)
            nPoints = numel(obj.points);
        end
        function nEntities = get.nEntities(obj)
            nEntities = numel(obj.entities);
        end
        function nObjects = get.nObjects(obj)
            nObjects = numel(obj.objects);
        end
        function nConstraints = get.nConstraints(obj)
            nConstraints = numel(obj.constraints);
        end
        
        %% static
        function motion = get.motion(obj)
            featureMotion = cell(0,1);            
            if obj.nPoints > 0
                featureMotion = vertcat(featureMotion,{obj.points.motion}');
            end
            if obj.nEntities > 0
                featureMotion = vertcat(featureMotion,{obj.entities.motion}');
            end
            if obj.nObjects > 0
                featureMotion = vertcat(featureMotion,{obj.objects.motion}');
            end
            if any(strcmp(featureMotion,'dynamic'))
                motion = 'dynamic';
            else
                motion = 'static';
            end
        end
        
        %% initialise points
        function obj = initialisePoints(obj,pointPositions)
            nPoints = size(pointPositions,1)/3;
            obj.points = Point();              %initialise
            obj.points(1:nPoints,1) = Point(); %preallocate
            %   initialise each point (can this be vectorised?)
            for i = 1:nPoints
                obj.points(i) = Point(pointPositions(mapping(i,3),:),i);
            end
        end
        
        %% initialise entities
        function obj = initialiseEntities(obj,entityTypes,entityParameters)
            nEntities = size(entityTypes,1);
            obj.entities = Entity();                %initialise
            obj.entities(1:nEntities,1) = Entity(); %preallocate
            for i = 1:nEntities
                obj.entities(i) = Entity(entityTypes{i},entityParameters{i},i);
            end
        end
        
        %% initialise objects
        function obj = initialiseObjects(obj,objectPoses,objectTypes,objectParameters)
            nObjects = size(objectTypes,1);
            obj.objects = Object();               %initialise
            obj.objects(1:nObjects,1) = Object(); %preallocate
            for i = 1:nObjects
                obj.objects(i) = Object(objectPoses{i},objectTypes{i},objectParameters{i},i);
            end
        end
        
        %% declare external
        obj = initialiseConstraints(obj,constraints)
        obj = removeUnobservedFeatures(obj,iObservedPoints,iObservedEntities,iObservedObjects)
    end
    
end

