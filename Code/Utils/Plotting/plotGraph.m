function plotHandles = plotGraph(config,graph,graphColour)
%PLOTGRAPH Summary of this function goes here
%   Detailed explanation goes here

hold on

%identify types
if (isempty(graph.iPoseVertices) || isempty(graph.iPointVertices))
    graph = graph.identifyTypes;
end

%% 1. plot camera
plotCameras = [];
for i = 1:numel(graph.iPoseVertices)
    iPose = graph.vertices(graph.iPoseVertices(i)).value;
    if strcmp(config.poseParameterisation,'SE3')
        iPose = LogSE3_Rxt(iPose);
    end
    plotiCamera = plotCamera('Location',iPose(1:3),'Orientation',rot(-iPose(4:6))); %LHS invert pose
    plotiCamera.Opacity = 0.1;
    plotiCamera.Size = 0.5;
    plotiCamera.Color = graphColour;
    plotCameras = [plotCameras plotiCamera];
end

%% 2. plot points
points = [graph.vertices(graph.iPointVertices).value];
plotPoints = plot3(points(1,:),points(2,:),points(3,:),'.');
set(plotPoints,'MarkerEdgeColor',graphColour)
set(plotPoints,'MarkerSize',10)

%% 3. plot entities & objects
plotPlanePoints = [];
planeHandles = [];
num = 0;
for i = 1:graph.nVertices
    switch graph.vertices(i).type
        case 'plane'
            num = num+1;
%             entityColour = rand(1,3);
            entityColour = graphColour;
            
            %get plane point positions   
            iPointVertices = graph.getConnectedVertices(i,'point');
            pointPositions = [graph.vertices(iPointVertices).value];
                        
            %plot plane points
%             plotPlanePoints(i) = plot3(pointPositions(1,:),pointPositions(2,:),pointPositions(3,:),'*');
%             set(plotPlanePoints(i),'MarkerEdgeColor',entityColour)
%             set(plotPlanePoints(i),'MarkerSize',5)
            
            %plot plane
            if config.plotPlanes
                planeParameters = graph.vertices(i).value;
                normal = planeParameters(1:3);
                distance = planeParameters(4);
                planeHandles(i) = plotPlane(normal,distance,pointPositions,graphColour);
            end
    end
end

%output plot handles
plotHandles = {plotCameras,plotPoints,plotPlanePoints,planeHandles};

end

