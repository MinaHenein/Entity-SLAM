 classdef NonlinearSolver
    %NONLINEARSOLVER Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        type
        iterations
        maxIterations
        threshold
        dX
        graphs 
        systems
        solveTime
        frames
    end
    
    methods
        %% constructor
        function obj = NonlinearSolver(config)
            obj.type          = config.solverType;
            obj.maxIterations = config.maxIterations;
            obj.threshold     = config.threshold;                           
        end

        %% solver
        function [obj] = solve(obj,config,graph0,measurementsCell)
            switch config.solverType
                case 'Gauss-Newton'
                    obj = obj.GNSolver(config,graph0,measurementsCell);
                case 'Levenberg-Marquardt'
                    obj = obj.LMSolver(config,graph0,measurementsCell);
                case 'Dog-Leg'
                    obj = obj.DLSolver(config,graph0,measurementsCell);
            end
                
        end
    end
    
end

