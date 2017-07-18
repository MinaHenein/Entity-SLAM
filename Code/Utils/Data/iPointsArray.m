function iPoints = iPointsArray(entity,entitiesList,surfacePointsEnd)
position = find(strcmp(entity,entitiesList)==1);
    if position == 1
        iPoints = 1:surfacePointsEnd(position);
    else
        iPoints = 1+surfacePointsEnd(position-1):surfacePointsEnd(position);    
    end
end