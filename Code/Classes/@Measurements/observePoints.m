function [obj] = observePoints(obj,config,map,camera,i)
%OBSERVEPOINTS simulates observations of points from the camera at time i
%   For each point observed by camera at time i, create an Observation
%   class instance representing this measurement.
%   observation.value is point observation - depends on point
%   parameterisation.

%% 1. points observed at this time
visiblePoints = obj.pointVisibility(:,i);
nVisiblePoints = sum(visiblePoints);
%index in ground truth map - will use these indexes as a unique identifier,
%but not for indexing
iVisiblePoints = find(visiblePoints);

%points already observed
if obj.map.nPoints > 0
    iObservedPoints = [obj.map.points.index]';
else
    iObservedPoints = [];
end

%% 2. constant properties
time           = config.dt*i;
covariance     = config.covPosePoint;
type           = 'pose-point';
switchable     = 0;
iPoses         = i;
iEntities      = [];
iChildEntities = [];
iObjects       = [];
iConstraints   = [];

%% 3. loop over visible points, create observations
for j = 1:nVisiblePoints
    %   3.1. indexing
    index = length([obj.observations.index])+1;
    %store index    
    obj.iPointObservations = [obj.iPointObservations; index];
    
    %index of observed point from ground truth map
    %this index acts as an identifier only
    jPoint = iVisiblePoints(j);
    
    %   3.2. get index in reconstructed map
    if any(iObservedPoints==jPoint)
        %   point has been observed before
        iPoints = find([obj.map.points.index]==jPoint);
        newFeature = 0;
    else
        %   unobserved - create new point in map reconstruction
        newPoint = Point();
        newPoint.index = jPoint;
        newFeature = 1;
        %error checking - compare to GT map - DONT USE THIS POSITION FOR ANYTHING ELSE
%         newPoint.position = map.points(jPoint).position(:,i);
        obj.map.points = [obj.map.points; newPoint];
        iPoints = obj.map.nPoints;
    end
    
    %   3.3. measurement value
    pointPositionAbsolute = map.points(jPoint).position(:,i);
    [~,positionRelative] = camera.checkObservation(config,i,pointPositionAbsolute);
    switch camera.pointParameterisation
        case 'euclidean'
            value = positionRelative;
        otherwise
            error('error: %s point parameterisation not implemented',camera.pointParameterisation)
    end     
    
    %   3.4. construct observation
    obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);
                                             
end

end

