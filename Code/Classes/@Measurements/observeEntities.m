function [obj] = observeEntities(obj,config,map,i)
%OBSERVEENTITIES simulates observations of entities from points and child
%entities
%   For each entity visible at time i, check if entity is observable via
%   points or child entities and simulate observation for each applicable
%   case.
%   Section 2. can be adjusted to simulate direct measurements of entity
%   parameters if desired. This would create pose-entity edges in the
%   graph.
%   Entities observed from points in section 2. are stored. This list is
%   used to check if any entities can be observed from child entities at
%   this time step, in section 3.

%% 1. entities observed at this time
visiblePoints = obj.pointVisibility(:,i);
visibleEntities = obj.entityVisibility(:,i);
nVisibleEntities = sum(visibleEntities);
%identifiers of entities observed at this time
iVisibleEntities = find(visibleEntities);

%associate entities with map reconstruction
if obj.map.nEntities > 0
    iObservedEntities = [obj.map.entities.index]';
else
    iObservedEntities = [];
end
   
%store identifier indexes of entities observed at this time
entitiesObserved = [];

%% 2. observe entities from their points
%values of these observations are indexes of points belonging to entity
%observed at this time

%   2.1. constant properties
time           = config.dt*i;
switchable     = 0;
iPoses         = [];
iChildEntities = [];
iObjects       = [];
iConstraints   = [];

%   2.2. loop over visible entities, check if observed from points and
%        create observations 
for j = 1:nVisibleEntities      
    %index of observed entity from ground truth map
    %this index acts as an identifier only
    jEntity = iVisibleEntities(j);
            
    %entity's points observed at this time step
    jEntityPoints = map.entities(jEntity).iPoints;
    jEntityPointsObserved = logical(visiblePoints(jEntityPoints));
    nVisiblePointsObserved = sum(jEntityPointsObserved);
       
    %check if enough points observed to observe entity
    %depends on type
    observationFlag = 0;
    switch map.entities(jEntity).type
        case 'plane'
            if nVisiblePointsObserved >= 3
                observationFlag = 1;
                covariance = config.covPointPlane;
                type = 'plane'; %%%%
            end
        case {'angle','distance'}
            %dont initialise from points
        otherwise
            error('%s entity type not yet defined',map.entities(jEntity).type)
    end
    
    %enough points to observe entity
    if observationFlag
        %entity is observed - store identifier
        entitiesObserved =[entitiesObserved; jEntity];
        
        %get entity index in reconstructed map
        if any(iObservedEntities==jEntity)
            %entity has been observed before
            iEntities = find([obj.map.entities.index]==jEntity);
            newFeature = 0;
        else
            %unobserved - create new entity in map reconstruction
            newEntity = Entity();
            newEntity.index = jEntity;
            newFeature = 1;
            obj.map.entities = [obj.map.entities; newEntity];
            iEntities = obj.map.nEntities;
            iObservedEntities = [obj.map.entities.index]';
        end
        
        %measurement index
        index = length([obj.observations.index])+1;
        
        %measurement is indexes of points observed
        jPoints = jEntityPoints(jEntityPointsObserved);
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
        obj.map.entities(iEntities).type = map.entities(jEntity).type;
        obj.map.entities(iEntities).iPoints = addIndex(obj.map.entities(iEntities).iPoints,...
                                                       iPoints,'col','unique');
        %add entity index to points        
        for k = 1:nPoints
            obj.map.points(iPoints(k)).iEntities = addIndex(obj.map.points(iPoints(k)).iEntities,...
                                                            iEntities,'col','unique');
        end

        %store index    
        obj.iEntityObservations = [obj.iEntityObservations; index];

    end
  
end

%% 3. observe entities from child entities
%order important - in map reconstruction, cant create compound entity until 
%child entities created
% constant properties
time           = config.dt*i;
switchable     = 0;
iPoses         = [];
iPoints        = [];
iObjects       = [];
iConstraints   = [];

%create correctly ordered list of entities to observe from child entities
iVisibleEntities = [map.entities(visibleEntities).index]';
entityStack = iVisibleEntities;
parentEntitiesObserved = [];
count = 0; %stop from looping forever
while (numel(entityStack) > 0) && count < 2*map.nEntities
    iCurrentEntity = entityStack(1);
    entityStack(1) = [];
    iChildEntities = map.entities(iCurrentEntity).iChildEntities;
    if ~isempty(iChildEntities)
        %get child entities observed at this time
        childEntitiesObserved = visibleEntities(iChildEntities);
        jChildEntitiesObserved = iChildEntities(childEntitiesObserved);
        %if child entities have been observed at this time, add to list
        if isempty(setdiff(jChildEntitiesObserved,entitiesObserved))
            parentEntitiesObserved = [parentEntitiesObserved; iCurrentEntity];
            %will observe, add to entitiesObserved
            entitiesObserved = [entitiesObserved; iCurrentEntity];
        else
        %if not, put on end of stack
            entityStack = [entityStack; iCurrentEntity];
        end
    end
    count = count + 1;
end

%create observations for entities on entityList
nParentEntitiesObserved = numel(parentEntitiesObserved);
for j = 1:nParentEntitiesObserved
    jParentEntity = parentEntitiesObserved(j);
    childEntities = map.entities(jParentEntity).iChildEntities;
    childEntitiesObserved = visibleEntities(childEntities);
    jChildEntitiesObserved = childEntities(childEntitiesObserved);
    nChildEntitiesObserved = numel(jChildEntitiesObserved);
    
    observationFlag = 0;
    %check if observation occurs
    switch map.entities(jParentEntity).type
        case 'plane'
            error('error: plane should not have child entities')
            %no child entities
        case 'angle'
            if nChildEntitiesObserved >= 2
                observationFlag = 1;
                covariance = config.covPlanePlaneAngle;        
                type = 'angle';
            end
        case 'distance'
            if nChildEntitiesObserved >= 2
                observationFlag = 1;
                covariance = config.covPlanePlaneDistance;
                type = 'distance';               
            end
        otherwise
            error('error: %s entity type not implemented',map.entities(jParentEntity).type)
    end
    if observationFlag
        %entity in map reconstruction
        if any(iObservedEntities==jParentEntity)
            %entity has been observed before
            iEntities = find([obj.map.entities.index]==jParentEntity);
            newFeature = 0;
        else
            %unobserved - create new entity in map reconstruction
            newEntity = Entity();
            newEntity.index = jParentEntity;
            newFeature = 1;
            obj.map.entities = [obj.map.entities; newEntity];
            iEntities = obj.map.nEntities;
        end

        %value - indexes of child entities visible
        iChildEntities = jChildEntitiesObserved;
        value = iChildEntities;

        %measurement index
        index = length([obj.observations.index])+1;
        
        %construct observation
        obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);
        %add properties to entity in map reconstruction
        obj.map.entities(iEntities).type = map.entities(jParentEntity).type;
        obj.map.entities(iEntities).iChildEntities = addIndex(obj.map.entities(iEntities).iChildEntities,...
                                                              iChildEntities,'col','unique');
        %add entity index to points
        nChildEntities = numel(iChildEntities);
        for k = 1:nChildEntities
            obj.map.entities(iChildEntities(k)).iParentEntities = ...
                addIndex(obj.map.entities(iChildEntities(k)).iParentEntities,iEntities,'col','unique');
        end
        
        %store index    
        obj.iEntityObservations = [obj.iEntityObservations; index];
    end
    
end


end

