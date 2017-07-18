function constructGroundTruthGraphFile(config,camera,map,measurements,fileName)
%CONSTRUCTGROUNDTRUTHGRAPHFILE Constructs graph file from ground truth
%camera, measurements and map
%   loop over poses (ie time steps)
%   create vertices from poses, points, entities and objects using ground
%   truth values from measurements of new features
%   create edges using measurements

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


%create initial pose vertex
vertexCount = vertexCount + 1;
iPoseVertices = [iPoseVertices,vertexCount];
vertexLabel = config.labelPoseVertex;
vertexIndex = vertexCount;
vertexValue = camera.pose(:,1);
formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);

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
                    %create point vertex
                    vertexCount = vertexCount + 1;
                    iPointVertices = [iPointVertices,vertexCount];
                    vertexLabel = config.labelPointVertex;
                    vertexIndex = vertexCount;
                    vertexValue = map.points(measurements.map.points(jObservation.iPoints).index).position(:,i);
                    formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
                    fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);
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
                %create pose vertex
                vertexCount = vertexCount + 1;
                iPoseVertices = [iPoseVertices,vertexCount];
                vertexLabel = config.labelPoseVertex;
                vertexIndex = vertexCount;
                vertexValue = camera.pose(:,i);
                formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
                fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);
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
                    %create plane vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                    vertexLabel = config.labelPlaneVertex;
                    vertexIndex = vertexCount;
                    vertexValue = map.entities(measurements.map.entities(entityIndex).index).parameters(:,i);
                    formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
                    fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);
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
                    %create angle vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                    vertexLabel = config.labelAngleVertex;
                    vertexIndex = vertexCount;
                    vertexValue = map.entities(measurements.map.entities(entityIndex).index).parameters(:,i);
                    formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
                    fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);
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
                    %create distance vertex
                    vertexCount = vertexCount + 1;
                    iEntityVertices = [iEntityVertices,vertexCount];
                    vertexLabel = config.labelDistanceVertex ;
                    vertexIndex = vertexCount;
                    vertexValue = map.entities(measurements.map.entities(entityIndex).index).parameters(:,i);
                    formatSpec = strcat('%s %d ',repmat(' %6.6f',1,numel(vertexValue)),'\n');
                    fprintf(fileID,formatSpec,vertexLabel,vertexIndex,vertexValue);
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

