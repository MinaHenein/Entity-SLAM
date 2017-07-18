function [obj] = observeConstraints(obj,config,map,i)
%OBSERVECONSTRAINTS Simulates observations of constraints.
%   For each constraint visible at time i, create observation class 
%   instance to represent constraint.
%   Indexes of features involved are stored. In some cases, direct
%   measurements of constraint can be made (ie fixed angle)

%% constraints observed at this time
visibleConstraints = obj.constraintVisibility(:,i);
nVisibleConstraints = sum(visibleConstraints);
iVisibleConstraints = find(visibleConstraints);

%***associate constraints with map reconstruction
if obj.map.nConstraints > 0
    iObservedConstraints = [obj.map.constraints.index]';
else
    iObservedConstraints = [];
end

%constant properties
time           = config.dt*i;
iPoses         = [];

%% loop over constraints visible at time i
for j = 1:nVisibleConstraints
    %new observation, increment count
%     observationCount = observationCount + 1;
    
    %index of observed constraint from ground truth map
    %this index acts as an identifier - dont use for indexing!!!
    jConstraint = iVisibleConstraints(j);
    
    %get index in reconstructed map
    if any(iObservedConstraints==jConstraint)
        %point has been observed before
        iConstraints = find([obj.map.constraints.index]==jConstraint);
    else
        %unobserved - create new point in map reconstruction
        newConstraint = Constraint();
        newConstraint.index = jConstraint;
        obj.map.constraints = [obj.map.constraints; newConstraint];
        iConstraints = obj.map.nConstraints;
    end
    
    %construct observation
    constraint = map.constraints(jConstraint);
    
    %add indexes to constraint in map reconstruction
    iPoints        = remapIndex(constraint.iPoints,obj.map,'Point');
    iEntities      = remapIndex(constraint.iEntities,obj.map,'Entity');
    iChildEntities = remapIndex(constraint.iChildEntities,obj.map,'Entity');
    iObjects       = remapIndex(constraint.iObjects,obj.map,'Object');
        
    %type
    %type = strcat(constraint.type,'-constraint');
    type = constraint.type;
    
    %switchable
    switchable = constraint.switchable;
    
    %new
    newFeature = 0;
    
    %observation index
    index = length([obj.observations.index])+1;
    
    %covariance
    switch constraint.type
        case 'point-plane'
            covariance = config.covPointPlane;
%             value      = [];
            value = 0; %assumption - points ON plane
        case 'plane-plane-angle'
            covariance = config.covPlanePlaneAngle;
%             value      = [];
            mu = zeros(size(config.stdPlanePlaneAngle));
            sigma = config.stdPlanePlaneAngle;
            angleGT = constraint.value;
            angleNoisy = addGaussianNoise(mu,sigma,angleGT);
            value      = angleNoisy;
        case 'plane-plane-fixedAngle'
            covariance = config.covPlanePlaneAngle;
            mu = zeros(size(config.stdPlanePlaneAngle));
            sigma = config.stdPlanePlaneAngle;
            angleGT = constraint.value;
%             angleNoisy = addGaussianNoise(mu,sigma,angleGT);
%             value      = angleNoisy;
            value = angleGT;
        case 'plane-plane-distance'
            covariance = config.covPlanePlaneDistance;
%             value      = [];
            mu = zeros(size(config.stdPlanePlaneDistance));
            sigma = config.stdPlanePlaneAngle;
            distanceGT = constraint.value;
            distanceNoisy = addGaussianNoise(mu,sigma,distanceGT);
            value      = distanceNoisy;
        case 'plane-plane-fixedDistance'
            covariance = config.covPlanePlaneDistance;
            mu = zeros(size(config.stdPlanePlaneDistance));
            sigma = config.stdPlanePlaneAngle;
            distanceGT = constraint.value;
            distanceNoisy = addGaussianNoise(mu,sigma,distanceGT);
            value      = distanceNoisy;
        case 'plane-cube'
            covariance = config.covPlaneCube;
            value      = [];
        case 'point-cube'
            covariance = config.covPointCube;
            value      = [];
        case 'point-rectangle'
            covariance = config.covPointPlane;
            value      = [];
        otherwise
            error('error: %s constraint type not implemented',constraint.type)
    end
    
    %construct observation
    obj.observations(index) = Observation(time,value,covariance,type,...
                                                 switchable,newFeature,iPoses,...
                                                 iPoints,iEntities,iChildEntities,...
                                                 iObjects,iConstraints,index);  
                                             
    %properties of constraint in reconstructed map
    obj.map.constraints(iConstraints).type           = type;
    obj.map.constraints(iConstraints).switchable     = switchable;
    obj.map.constraints(iConstraints).iObjects       = iObjects;
    obj.map.constraints(iConstraints).iEntities      = iEntities;
    obj.map.constraints(iConstraints).iChildEntities = iChildEntities;
    obj.map.constraints(iConstraints).iPoints        = iPoints;
    
    %add constraint index to features involved     
    for j = iObjects'
        obj.map.objects(j).iConstraints  = addIndex(obj.map.objects(j).iConstraints,...
                                                   iConstraints,'col','unique');
    end
    for j = iEntities'
        obj.map.entities(j).iConstraints = addIndex(obj.map.entities(j).iConstraints,...
                                                    iConstraints,'col','unique');
    end
    for j = iChildEntities'
        obj.map.entities(j).iConstraints = addIndex(obj.map.entities(j).iConstraints,...
                                                    iConstraints,'col','unique');
    end
    for j = iPoints'
        obj.map.points(j).iConstraints   = addIndex(obj.map.points(j).iConstraints,...
                                                    iConstraints,'col','unique');
    end
    
    %store index    
    obj.iConstraintObservations = [obj.iConstraintObservations; index];
                                               
end

end

