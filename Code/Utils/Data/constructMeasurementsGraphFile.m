function constructMeasurementsGraphFile(config,camera,measurements,fileName)
%CONSTRUCTGRAPHFILE constructs graph file from measurements
%   loop over each measurement
%   check types involved and their indexes
%   determine vertices involved (and if new vertices must be created)
%   vertex properties
%       -type
%       -index
%       -value
%   add edge for each measurement (*are there any ignored?)
%   edge properties
%       -type
%       -vertex indexes (from list, to list)
%       -value
%       -covariance

%open file
if ispc
    fileID = fopen(strcat(config.savePath,'\Data\GraphFiles\',fileName),'w');
elseif isunix || ismac
    fileID = fopen(strcat(config.savePath,'/Data/GraphFiles/',fileName),'w');
end

%indexing
vertexCount = 0;
edgeCount = 0;
% vertexCount = -1;
% edgeCount = -1;
iPoseVertices = [];
iPointVertices = [];
iEntityVertices = [];
iObjectVertices = [];

%count initial pose vertex
vertexCount = vertexCount + 1;
iPoseVertices = [iPoseVertices,vertexCount];

%loop over observations
for i = 1:camera.nPoses
    
    %loop over observations from this time
    time = i*config.dt;
    iObservations = measurements.getObservations(time,'time');
    nObservations = numel(iObservations);
    for j = 1:nObservations
        jObservation = measurements.observations(iObservations(j));
        switch jObservation.type
            case 'pose-point'
                if jObservation.newFeature
                    %count point vertex
                    vertexCount = vertexCount + 1;
                    iPointVertices = [iPointVertices,vertexCount];
                end
                %create edge
                edgeLabel = config.labelPosePointEdge;
                verticesIn = iPoseVertices(jObservation.iPoses);
                verticesOut = iPointVertices(jObservation.iPoints);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %d',1,numel(verticesOut)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,verticesOut,edgeValue,edgeCovariance);
            case 'odometry'
                %count pose vertex
                vertexCount = vertexCount + 1;
                iPoseVertices = [iPoseVertices,vertexCount];
                %create odometry edge
                edgeLabel = config.labelPosePoseEdge;
                verticesIn = iPoseVertices(jObservation.iPoses(1));
                verticesOut = iPoseVertices(jObservation.iPoses(2));
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %d',1,numel(verticesOut)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,verticesOut,edgeValue,edgeCovariance);
            case 'point-plane'  
                %check if new feature
                entityIndex = jObservation.iEntities;
                if numel(iEntityVertices) < entityIndex
                    %count plane vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                end
                %create edge
                edgeLabel = config.labelPointPlaneEdge;
                verticesIn = iPointVertices(jObservation.iPoints);
                verticesOut = iEntityVertices(entityIndex);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %d',1,numel(verticesOut)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,verticesOut,edgeValue,edgeCovariance);
            case 'plane'
                %do nothing
                %leave this here in case direct pose-plane observations added
            case 'angle'
                %do nothing
            case 'distance'
                %do nothing
            case 'plane-plane-angle'
                %check if new feature
                entityIndex = jObservation.iEntities;
                if numel(iEntityVertices) < entityIndex
                    %count angle vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                end
                %create edge
                edgeLabel = config.labelAngleEdge;
                verticesIn = iEntityVertices(jObservation.iChildEntities);
                verticesOut = iEntityVertices(entityIndex);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %d',1,numel(verticesOut)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,verticesOut,edgeValue,edgeCovariance);
            case 'plane-plane-distance'
                %check if new feature
                entityIndex = jObservation.iEntities;
                if numel(iEntityVertices) < entityIndex
                    %count distance vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                end
                %create edge
                edgeLabel = config.labelDistanceEdge;
                verticesIn = iEntityVertices(jObservation.iChildEntities);
                verticesOut = iEntityVertices(entityIndex);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %d',1,numel(verticesOut)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,verticesOut,edgeValue,edgeCovariance);
            case 'plane-plane-fixedAngle'
                %create edge
                edgeLabel = config.labelFixedAngleEdge;
                verticesIn = iEntityVertices(jObservation.iChildEntities);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,edgeValue,edgeCovariance);
            case 'plane-plane-fixedDistance'
                %create edge
                edgeLabel = config.labelFixedDistanceEdge;
                verticesIn = iEntityVertices(jObservation.iChildEntities);
                edgeValue = jObservation.value;               
                edgeCovariance = covToUpperTriVec(jObservation.covariance); 
                formatSpec = strcat('%s',...
                                    repmat(' %d',1,numel(verticesIn)),...
                                    repmat(' %.6f',1,numel(edgeValue)),...
                                    repmat(' %.6f',1,numel(edgeCovariance)),'\n');
                fprintf(fileID,formatSpec,edgeLabel,verticesIn,edgeValue,edgeCovariance);
            otherwise
                error('%node type not implemented')
        end
    end
    
end

%close file
fclose(fileID);

end

