function [obj] = initialiseConstraints(obj,constraints)
%INITIALISECONSTRAINTS Summary of this function goes here
%   Detailed explanation goes here

nConstraints = size(constraints,1);
obj.constraints = Constraint();
obj.constraints(nConstraints,1) = Constraint();

for i = 1:nConstraints
    %construct constraint
    type           = constraints{i,5};
    value          = constraints{i,6};
    iObjects       = constraints{i,1};
    iEntities      = constraints{i,2};
    iChildEntities = constraints{i,3};
    iPoints        = constraints{i,4};
    index          = i;
    obj.constraints(i) = Constraint(type,value,iObjects,iEntities,iChildEntities,iPoints,index);
    %pair points/entities/objects
    for j = iObjects'
        obj.objects(j).iEntities    = addIndex(obj.objects(j).iEntities,iEntities,'col','unique');
        obj.objects(j).iPoints      = addIndex(obj.objects(j).iPoints,iPoints,'col','unique');
        obj.objects(j).iConstraints = addIndex(obj.objects(j).iConstraints,i,'col','unique');
    end
    for j = iEntities'
        obj.entities(j).iObjects       = addIndex(obj.entities(j).iObjects,iObjects,'col','unique');
        obj.entities(j).iChildEntities = addIndex(obj.entities(j).iChildEntities,iChildEntities,'col','unique');
        obj.entities(j).iPoints        = addIndex(obj.entities(j).iPoints,iPoints,'col','unique');
        obj.entities(j).iConstraints   = addIndex(obj.entities(j).iConstraints,i,'col','unique');
    end
    for j = iChildEntities'
        obj.entities(j).iObjects        = addIndex(obj.entities(j).iObjects,iObjects,'col','unique');
        obj.entities(j).iParentEntities = addIndex(obj.entities(j).iParentEntities,iEntities,'col','unique');
        obj.entities(j).iConstraints    = addIndex(obj.entities(j).iConstraints,i,'col','unique');
    end
    for j = iPoints'
        obj.points(j).iObjects     = addIndex(obj.points(j).iObjects,iObjects,'col','unique');
        obj.points(j).iEntities    = addIndex(obj.points(j).iEntities,iEntities,'col','unique');
        obj.points(j).iConstraints = addIndex(obj.points(j).iConstraints,i,'col','unique');
    end
end


end

