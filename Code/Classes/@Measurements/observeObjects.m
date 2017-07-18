function [obj] = observeObjects(obj,config,map,i)
%OBSERVEPOINTS simulates observations of objects from points and entities
%   For each object visible at time i, check if object is observable via
%   points or entities and simulate observation for each applicable case.
%   Section 2. can be adjusted to simulate direct measurements of object
%   parameters if desired. This would create pose-object edges in the
%   graph.

visiblePoints = obj.pointVisibility(:,i);
visibleEntities = obj.entityVisibility(:,i);
visibleObjects = obj.objectVisibility(:,i);
%entities observed at this time
nVisibleObjects = sum(visibleObjects);
iVisibleObjects = find(visibleObjects);

%associate entities with map reconstruction
if obj.map.nObjects > 0
    iObservedObjects = [obj.map.objects.index]';
else
    iObservedObjects = [];
end

%% 1. observe objects from points
% constant properties
time           = config.dt*i;
switchable     = 0;
iPoses         = [];
iEntities      = [];
iChildEntities = [];
iConstraints   = [];

for j = 1:nVisibleObjects    
    %index of observed object from ground truth map
    %this index acts as an identifier - dont use for indexing!!!
    jObject = iVisibleObjects(j);
            
    %objects points observed at this time step
    jObjectPoints = map.objects(jObject).iPoints;
    jObjectPointsObserved = logical(visiblePoints(jObjectPoints));
    nVisiblePointsObserved = sum(jObjectPointsObserved);
       
    %check if enough points observed to observe entity
    %depends on type
    observationFlag = 0;
    switch map.objects(jObject).type
        case 'cube'
            if nVisiblePointsObserved >= 50
                observationFlag = 1;
                covariance = config.covPointCube;
                type = 'point-cube';
            end
        case 'rectangle'
            if nVisiblePointsObserved >= 3
                observationFlag = 1;
                covariance = config.covPointPlane;
                type = 'point-rectangle';
            end
        otherwise
            error('%s object type not yet defined',map.objects(jObject).type)
    end
    
    if observationFlag
        %get object index in reconstructed map
        if any(iObservedObjects==jObject)
            %entity has been observed before
            iObjects = find([obj.map.objects.index]==jObject);
            newFeature = 0;
        else
            %unobserved - create new object in map reconstruction
            newObject = Object();
            newObject.index = jObject;
            newFeature = 1;
            obj.map.objects = [obj.map.objects; newObject];
            iObjects = obj.map.nObjects;
            iObservedObjects = [obj.map.objects.index]';
        end
        
        %measurement index
%         index = observationCount;
        index = length([obj.observations.index])+1;
        assert(index == length([obj.observations.index])+1)
        
        %measurement is indexes of points observed
        jPoints = jObjectPoints(jObjectPointsObserved);
        nPoints = numel(jPoints);
        %get point indexes in reconstructed map
        iPoints = remapIndex(jPoints,obj.map,'Point');
        value = iPoints;

        %construct observation
        obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);
                                             
        %map reconstruction - store properties
        obj.map.objects(iObjects).type = map.objects(jObject).type;
        obj.map.objects(iObjects).iPoints = addIndex(obj.map.objects(iObjects).iPoints,...
                                                       iPoints,'col','unique');
        %add entity index to points        
        for k = 1:nPoints
            obj.map.points(iPoints(k)).iObjects = addIndex(obj.map.points(iPoints(k)).iObjects,...
                                                            iObjects,'col','unique');
        end

%         %***can create direct measurement of object parameters here
%         %   create another observation, add noise to GT parameters
%         %new observation, increment count
%         observationCount = observationCount + 1;
%         type = 'pose-cube';
%         iPoses = i;
%         objectParameters = map.object(jObject).parameters;
%         switch map.objects(jObject).type
%             case 'cube'
%                 mu = zeros(size(config.stdPointCube));
%                 sigma = config.stdPointCube;
%             case {'angle','distance'}
%                 %dont initialise from points
%             otherwise
%                 error('%s entity type not yet defined',map.entities(jEntity).type)
%         end
        
        %store index    
        obj.iObjectObservations = [obj.iObjectObservations; index];

    end
  
end

%% 2. observe objects from entities
% constant properties
time           = config.dt*i;
switchable     = 0;
iPoses         = [];
iEntities      = [];
iChildEntities = [];
iConstraints   = [];

for j = 1:nVisibleObjects    
    %index of observed object from ground truth map
    %this index acts as an identifier - dont use for indexing!!!
    jObject = iVisibleObjects(j);
            
    %objects points observed at this time step
    jObjectEntities = map.objects(jObject).iEntities;
    jObjectEntitiesObserved = logical(visibleEntities(jObjectEntities));
    nVisibleEntitiesObserved = sum(jObjectEntitiesObserved);
       
    %check if enough points observed to observe entity
    %depends on type
    observationFlag = 0;
    switch map.objects(jObject).type
        case 'cube'
            if nVisibleEntitiesObserved >= 3
                observationFlag = 1;
                covariance = config.covPlaneCube;
                type = 'plane-cube';
            end
        case 'rectangle'
            %dont observe from entities
        otherwise
            error('%s object type not yet defined',map.objects(jObject).type)
    end
    
    if observationFlag
        %get object index in reconstructed map
        if any(iObservedObjects==jObject)
            %object has been observed before
            iObjects = find([obj.map.objects.index]==jObject);
            newFeature = 0;
        else
            %unobserved - create new entity in map reconstruction
            newObject = Object();
            newObject.index = jObject;
            newFeature = 1;
            obj.map.objects = [obj.map.objects; newObject];
            iObjects = obj.map.nObjects;
            iObservedObjects = [obj.map.objects.index]';
        end
        
        %measurement index
%         index = observationCount;
        index = length([obj.observations.index])+1;
        assert(index == length([obj.observations.index])+1)
        
        %measurement is indexes of points observed
        jEntities = jObjectEntities(jObjectEntitiesObserved);
        nEntities = numel(jEntities);
        %get point indexes in reconstructed map
        iEntities = remapIndex(jEntities,obj.map,'Entity');
        value = iEntities;

        %construct observation
        obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);
                                             
        %map reconstruction - store properties
        obj.map.objects(iObjects).type = map.objects(jObject).type;
        obj.map.objects(iObjects).iEntities = addIndex(obj.map.objects(iObjects).iEntities,...
                                                       iEntities,'col','unique');
        %add object index to entities       
        for k = 1:nEntities
            obj.map.entities(iEntities(k)).iObjects = addIndex(obj.map.entities(iEntities(k)).iObjects,...
                                                               iObjects,'col','unique');
        end

%         %***can create direct measurement of object parameters here
%         %   create another observation, add noise to GT parameters
%         %new observation, increment count
%         observationCount = observationCount + 1;
%         type = 'pose-cube';
%         iPoses = i;
%         objectParameters = map.object(jObject).parameters;
%         switch map.objects(jObject).type
%             case 'cube'
%                 mu = zeros(size(config.stdPointCube));
%                 sigma = config.stdPointCube;
%             case {'angle','distance'}
%                 %dont initialise from points
%             otherwise
%                 error('%s entity type not yet defined',map.entities(jEntity).type)
%         end

        %store index    
        obj.iObjectObservations = [obj.iObjectObservations; index];

    end
  
end



end

