function [obj] = removeUnobservedFeatures(obj,config,camera)
%REMOVEUNOBSERVEDFEATURES removes points, entities, objects, constraints
%that are never observed by the camera
%   inputs: map and camera
%   output: map containing only observed features
%
%   1. check which points, entities, objects , constraints visible to the
%      camera at each time step. For more details, look in visibility.m
%   2. assign new indexes to observed features, and map all old indexes to
%      new ones. Remove unobserved features from map


%% 1. get visibility of features
[pointVisibility,entityVisibility,objectVisibility,constraintVisibility] = visibility(obj,config,camera);

%% 2. remove unobserved features, remap indexes
%find observed features
observedPoints      = any(pointVisibility,2);
observedEntities    = any(entityVisibility,2);
observedObjects     = any(objectVisibility,2);
observedConstraints = any(constraintVisibility,2);
%dont remove unobserved constraints - still used in graph

%new indexes
iObservedPoints   = cumsum(observedPoints);
iObservedPoints(~observedPoints)     = 0;
iObservedEntities = cumsum(observedEntities);
iObservedEntities(~observedEntities) = 0;
iObservedObjects  = cumsum(observedObjects);
iObservedObjects(~observedObjects)   = 0;
iObservedConstraints = cumsum(observedConstraints);
iObservedConstraints(~observedConstraints) = 0;

for i = 1:obj.nPoints
    obj.points(i).index        = iObservedPoints(obj.points(i).index);
    obj.points(i).iObjects     = iObservedObjects(obj.points(i).iObjects);
    obj.points(i).iEntities    = iObservedEntities(obj.points(i).iEntities);
    obj.points(i).iConstraints = iObservedConstraints(obj.points(i).iConstraints);
    %remove zeros
    obj.points(i).iObjects     = obj.points(i).iObjects(logical(obj.points(i).iObjects));
    obj.points(i).iEntities    = obj.points(i).iEntities(logical(obj.points(i).iEntities));
    obj.points(i).iConstraints = obj.points(i).iConstraints(logical(obj.points(i).iConstraints));
end
for i = 1:obj.nEntities
    obj.entities(i).index           = iObservedEntities(obj.entities(i).index);
    obj.entities(i).iObjects        = iObservedObjects(obj.entities(i).iObjects);
    obj.entities(i).iParentEntities = iObservedEntities(obj.entities(i).iParentEntities);
    obj.entities(i).iChildEntities  = iObservedEntities(obj.entities(i).iChildEntities);
    obj.entities(i).iPoints         = iObservedPoints(obj.entities(i).iPoints);
    obj.entities(i).iConstraints    = iObservedConstraints(obj.entities(i).iConstraints);
    %remove zeros
    obj.entities(i).iObjects        = obj.entities(i).iObjects(logical(obj.entities(i).iObjects));  
    obj.entities(i).iParentEntities = obj.entities(i).iParentEntities(logical(obj.entities(i).iParentEntities));
    obj.entities(i).iChildEntities  = obj.entities(i).iChildEntities(logical(obj.entities(i).iChildEntities));
    obj.entities(i).iPoints         = obj.entities(i).iPoints(logical(obj.entities(i).iPoints));
    obj.entities(i).iConstraints    = obj.entities(i).iConstraints(logical(obj.entities(i).iConstraints));
end
for i = 1:obj.nObjects
    obj.objects(i).index        = iObservedObjects(obj.objects(i).index);
    obj.objects(i).iEntities    = iObservedEntities(obj.objects(i).iEntities);
    obj.objects(i).iPoints      = iObservedPoints(obj.objects(i).iPoints);
    obj.objects(i).iConstraints = iObservedConstraints(obj.objects(i).iConstraints);
    %remove zeros
    obj.objects(i).iEntities    = obj.objects(i).iEntities(logical(obj.objects(i).iEntities));
    obj.objects(i).iPoints      = obj.objects(i).iPoints(logical(obj.objects(i).iPoints));
    obj.objects(i).iConstraints = obj.objects(i).iConstraints(logical(obj.objects(i).iConstraints));
end
for i = 1:obj.nConstraints
    obj.constraints(i).index           = iObservedConstraints(obj.constraints(i).index);
    obj.constraints(i).iObjects        = iObservedObjects(obj.constraints(i).iObjects);
    obj.constraints(i).iEntities       = iObservedEntities(obj.constraints(i).iEntities);
    obj.constraints(i).iChildEntities  = iObservedEntities(obj.constraints(i).iChildEntities);
    obj.constraints(i).iPoints         = iObservedPoints(obj.constraints(i).iPoints);
    %remove zeros
    obj.constraints(i).iObjects        = obj.constraints(i).iObjects(logical(obj.constraints(i).iObjects));  
    obj.constraints(i).iEntities       = obj.constraints(i).iEntities(logical(obj.constraints(i).iEntities));
    obj.constraints(i).iChildEntities  = obj.constraints(i).iChildEntities(logical(obj.constraints(i).iChildEntities));
    obj.constraints(i).iPoints         = obj.constraints(i).iPoints(logical(obj.constraints(i).iPoints));
end

obj.points      = obj.points(observedPoints);
obj.entities    = obj.entities(observedEntities);
obj.objects     = obj.objects(observedObjects);
obj.constraints = obj.constraints(observedConstraints);

%% 3. Fix associations
%eg if point only observed when entity not observed, point cant be part of entity
[pointVisibility,entityVisibility,objectVisibility,constraintVisibility] = visibility(obj,config,camera);
for i = 1:obj.nEntities
    %points
    entityNotVisible = ~entityVisibility(i,:);
    entityPoints = obj.entities(i).iPoints;
    entityPointsVisibility = pointVisibility(entityPoints,:);
    pointsInEntityVisibility = entityPointsVisibility;
    pointsInEntityVisibility(:,entityNotVisible) = 0;
    pointsInEntity = any(pointsInEntityVisibility,2);
    pointsNotInEntity = entityPoints(~pointsInEntity);
    nPointsNotInEntity = numel(pointsNotInEntity);
    obj.entities(i).iPoints = entityPoints(pointsInEntity);
    for j = 1:nPointsNotInEntity
        obj.points(pointsNotInEntity(j)).iEntities = setdiff(obj.points(pointsNotInEntity(j)).iEntities,i);
    end
    
    %child entities
    entityChildEntities = obj.entities(i).iChildEntities;
    entityChildEntitiesVisibility = entityVisibility(entityChildEntities,:);
    childEntitiesInEntityVisibility = entityChildEntitiesVisibility;
    childEntitiesInEntityVisibility(:,entityNotVisible) = 0;
    childEntitiesInEntity = any(childEntitiesInEntityVisibility,2);
    childEntitiesNotInEntity = entityPoints(~childEntitiesInEntity);
    nChildEntitiesNotInEntity = numel(childEntitiesNotInEntity);
    obj.entities(i).iChildEntities = entityChildEntities(childEntitiesInEntity);
    for j = 1:nChildEntitiesNotInEntity
        obj.entities(childEntitiesNotInEntity(j)).iParentEntities = setdiff(obj.entities(childEntitiesNotInEntity(j)).iParentEntities,i);
    end
end

for i = 1:obj.nObjects
    %points
    objectNotVisible = ~objectVisibility(i,:);
    objectPoints = obj.objects(i).iPoints;
    objectPointsVisibility = pointVisibility(objectPoints,:);
    pointsInObjectVisibility = objectPointsVisibility;
    pointsInObjectVisibility(:,objectNotVisible) = 0;
    pointsInObject = any(pointsInObjectVisibility,2);
    pointsNotInObject = objectPoints(~pointsInObject);
    nPointsNotInObject = numel(pointsNotInObject);
    obj.objects(i).iPoints = objectPoints(pointsInObject);
    for j = 1:nPointsNotInObject
        obj.points(pointsNotInObject(j)).iObjects = setdiff(obj.points(pointsNotInObject(j)).iObjects,i);
    end
    
    %objects
    objectNotVisible = ~objectVisibility(i,:);
    objectEntities = obj.objects(i).iEntities;
    objectEntitiesVisibility = pointVisibility(objectEntities,:);
    entitiesInObjectVisibility = objectEntitiesVisibility;
    entitiesInObjectVisibility(:,objectNotVisible) = 0;
    entitiesInObject = any(entitiesInObjectVisibility,2);
    entitiesNotInObject = objectEntities(~entitiesInObject);
    nEntitiesNotInObject = numel(entitiesNotInObject);
    obj.objects(i).iEntities = objectEntities(entitiesInObject);
    for j = 1:nEntitiesNotInObject
        obj.entities(entitiesNotInObject(j)).iObjects = setdiff(obj.entities(entitiesNotInObject(j)).iObjects,i);
    end
end

end

