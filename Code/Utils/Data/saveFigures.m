function saveFigures(config,experimentPath,trials)
%GENERATEFIGURES Summary of this function goes here
%   Detailed explanation goes here

%% 1. Load
saveFigures = 1;
for j = trials
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end 
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(j));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path

    groundTruthCell  = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruth.graph'),'noConstraints');
    groundTruthCellS = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruthS.graph'));
    resultsCell    = graphFileToCell(config,strcat(trialFilePath,sep,'results.graph'));
    resultsCellP   = graphFileToCell(config,strcat(trialFilePath,sep,'resultsP.graph'));
    resultsCellPA  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPA.graph'));
    resultsCellSP  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSP.graph'));
    resultsCellSPA = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPA.graph'));
    
    %compute errors
    graphGT   = Graph(config,groundTruthCell);
    graphGTS  = Graph(config,groundTruthCellS);
    graphN    = Graph(config,resultsCell);
    graphNP   = Graph(config,resultsCellP);
    graphNPA  = Graph(config,resultsCellPA);
    graphNSP  = Graph(config,resultsCellSP);
    graphNSPA = Graph(config,resultsCellSPA);
    results    = errorAnalysis(config,graphGT,graphN);
    resultsP   = errorAnalysis(config,graphGT,graphNP);
    resultsPA  = errorAnalysis(config,graphGT,graphNPA);
    resultsSP  = errorAnalysis(config,graphGTS,graphNSP);
    resultsSPA = errorAnalysis(config,graphGTS,graphNSPA);
    
    %% 2. Plot Figure
    h = figure; 
%         set(h,'units','normalized','outerposition',[0 0 1 1])
 
    subplot(2,5,1);
    title('no constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    subplot(2,5,2)
    title('planar constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    subplot(2,5,3)
    title('planar & angle constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    subplot(2,5,4)
    title('segmented planar constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    subplot(2,5,5)
    title('segmented planar & angle constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPA,[0 0 1])

    subplot(2,5,6)
    title('no constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    subplot(2,5,7)
    title('planar constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    subplot(2,5,8)
    title('planar & angle constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    subplot(2,5,9)
    title('segmented planar constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    subplot(2,5,10)
    title('segmented planar & angle constraints')
    if config.axisEqual; axis equal; end
    axis(config.axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z')
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPA,[0 0 1])

    titleCell = {'Comparison',...
                [' (rngSeed = ',num2str(config.rngSeed,3),...
                ', sigmaOdometry = ',mat2str(config.stdPosePose',3),...
                ', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
    suptitle(titleCell)

    %% 3. Export Figure
    if saveFigures
        imagePath = strcat(config.savePath,sep,'Data',sep,'GraphFiles',sep,experimentPath,sep,'Figures');
        if ~exist(imagePath,'dir'); mkdir(imagePath); end;
        imageName = strcat(imagePath,sep,'Trial_',num2str(j));
        print(h,imageName,'-dsvg')
        delete(h);
    end
end


end

