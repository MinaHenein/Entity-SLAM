classdef Measurements
    %MEASUREMENTS Class used to simulate and store measurements of points,
    %entities, objects and constraints.
    %   Odometry, point, entity, object and constraint observations
    %   simulated based on visibility of features. Where direct
    %   observations can be made, measurements are simulated by adding
    %   gaussian noise to ground truth values from map. In other cases,
    %   measurement is indexes of features involved. 
    %   See Observation class for more details on measurement
    %   representation.
    
    properties
        observations
        iOdometryObservations
        iPointObservations
        iEntityObservations
        iObjectObservations
        iConstraintObservations
        map
        pointVisibility
        entityVisibility
        objectVisibility
        constraintVisibility
    end
    
    properties (Dependent)
        nObservations
        nOdometryObservations
        nPointObservations
        nEntityObservations
        nObjectObservations
        nConstraintObservations
    end
    
    methods
        %% Constructor
        function obj = Measurements(config,map,camera)
            obj = simulateObservations(obj,config,map,camera);
        end
        
        %% sizes
        function nObservations = get.nObservations(obj)
            nObservations = numel(obj.observations);
        end
        function nOdometryObservations = get.nOdometryObservations(obj)
            nOdometryObservations = numel(obj.iOdometryObservations);
        end
        function nPointObservations = get.nPointObservations(obj)
            nPointObservations = numel(obj.iPointObservations);
        end
        function nEntityObservations = get.nEntityObservations(obj)
            nEntityObservations = numel(obj.iEntityObservations);
        end
        function nObjectObservations = get.nObjectObservations(obj)
            nObjectObservations = numel(obj.iObjectObservations);
        end
        function nConstraintObservations = get.nConstraintObservations(obj)
            nConstraintObservations = numel(obj.iConstraintObservations);
        end

    end
    
end

