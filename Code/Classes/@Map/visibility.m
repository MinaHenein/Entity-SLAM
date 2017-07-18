function [pointVisibility,entityVisibility,objectVisibility,constraintVisibility] = visibility(obj,config,camera)
%VISIBILITY determines which points, entities, objects and constraints are
%visible to the camera at each time step
%   inputs: map and camera
%   outputs: arrays for points, entities, objects and constraints. size is
%   no. of features x no. camera poses. Entries are 0 if unobserved, 1 if
%   observed.

%feature visibility
pointVisibility      = false(obj.nPoints,camera.nPoses);
entityVisibility     = false(obj.nEntities,camera.nPoses);
objectVisibility     = false(obj.nObjects,camera.nPoses);
constraintVisibility = false(obj.nConstraints,camera.nPoses);

%% 1. point visibility based on camera observations
%point visible if it is within FOV of camera
for i = 1:camera.nPoses
    for j = 1:obj.nPoints        
        pointPosition = obj.points(j).position(:,i);
        pointVisibility(j,i) = camera.checkObservation(config,i,pointPosition);         
    end
end

%% 2. entity visibility based on points
%entity visible if enough points to estimate it are visible
for i = 1:camera.nPoses
    for j = 1:obj.nEntities
        jPoints = obj.entities(j).iPoints;
        visiblePoints = pointVisibility(jPoints,i);
        nVisiblePoints = sum(visiblePoints);
        switch obj.entities(j).type
            case 'plane'
                if nVisiblePoints >= 3
                    entityVisibility(j,i) = 1;
                end
            case {'angle','distance'}
                %cant initialise from points, do nothing
            otherwise
                error('error: %s entity type not implemented',obj.entities(j).type)
        end
    end
end

%% 3. entity visibility based on child entities
%entity visible if enough child entities visible to estimate it
for i = 1:camera.nPoses
    for j = 1:obj.nEntities
        jChildEntities = obj.entities(j).iChildEntities;
        visibleEntities = entityVisibility(jChildEntities,i);
        nVisibleEntities = sum(visibleEntities);
        switch obj.entities(j).type
            case 'plane'
                %do nothing
            case {'angle','distance'}
                if nVisibleEntities >= 2
                    entityVisibility(j,i) = 1;
                end
            otherwise
                error('error: %s entity type not implemented',obj.entities(j).type)
        end
    end
end

%% 4. object visibility based on points
%object visible if enough points visible to estimate it
for i = 1:camera.nPoses
    for j = 1:obj.nObjects
        jPoints = obj.objects(j).iPoints;
        visiblePoints = pointVisibility(jPoints,i);
        nVisiblePoints = sum(visiblePoints);
        switch obj.objects(j).type
            case 'cube'
                if nVisiblePoints >= 50
                    objectVisibility(j,i) = 1;
                end
            case 'rectangle'
                if nVisiblePoints >= 3
                    objectVisibility(j,i) = 1;
                end
            otherwise
                error('error: %s entity type not implemented',obj.objects(j).type)
        end
    end
end

%% 5. object visibility based on entities
%object visible if enough entities visible to observe it
for i = 1:camera.nPoses
    for j = 1:obj.nObjects
        jEntities = obj.objects(j).iEntities;
        visibleEntities = entityVisibility(jEntities,i);
        nVisibleEntities = sum(visibleEntities);
        switch obj.objects(j).type
            case 'cube'
                if nVisibleEntities >= 3
                    objectVisibility(j,i) = 1;
                end
            case 'rectangle'
                %dont observe from entities
%                 if nVisibleEntities >= 1
%                     objectVisibility(j,i) = 1;
%                 end
            otherwise
                error('error: %s entity type not implemented',obj.objects(j).type)
        end
    end
end

%% 6. constraint visibility at each time
%constraint visible if all features it associates visible at same time
for i = 1:camera.nPoses
    for j = 1:obj.nConstraints
        %features involved in constraint j
        jObjects       = obj.constraints(j).iObjects;
        jEntities      = obj.constraints(j).iEntities;
        jChildEntities = obj.constraints(j).iChildEntities;
        jPoints        = obj.constraints(j).iPoints;
        %visibility of features
        jObjectsVisibility = objectVisibility(jObjects,i);
        jEntitiesVisibility = entityVisibility(jEntities,i);
        jChildEntitiesVisibility = entityVisibility(jChildEntities,i);
        jPointsVisibility = pointVisibility(jPoints,i);
        %all features visible
        if all(jObjectsVisibility) && all(jEntitiesVisibility) ...
           && all(jChildEntitiesVisibility) && all(jPointsVisibility)
            constraintVisibility(j,i) = 1;
        end
        
        %observe angles as long as both planes seen before
        constraintType = obj.constraints(j).type;
        if strcmp(constraintType,'plane-plane-fixedAngle')
            iPlanes = obj.constraints(j).iChildEntities;
            iPlanesVisibility = entityVisibility(iPlanes,1:i);
            if isequal(any(iPlanesVisibility,2),[1 1]')
                constraintVisibility(j,i) = 1;
            end
        end
        
        %if constraint seen before (ie already in graph), dont recreate
        if any(constraintVisibility(j,1:i-1))
            constraintVisibility(j,i) = 0;
        end
        
    end
end

end
