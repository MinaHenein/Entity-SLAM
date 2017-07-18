clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Load
saveFigures = 1;
% experimentPath = 'Experiment_14_FullComparison';
experimentPath = 'Experiment_14_FullComparison_Starting_PlanarInfo';
for i = 1:160
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end 
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(i));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path

    groundTruthCell  = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruth.graph'),'noConstraints');
    groundTruthCellS = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruthS.graph'));
    resultsCell    = graphFileToCell(config,strcat(trialFilePath,sep,'results.graph'));
    resultsCellP   = graphFileToCell(config,strcat(trialFilePath,sep,'resultsP.graph'));
    resultsCellPA  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPA.graph'));
    resultsCellSP  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSP.graph'));
    resultsCellSPA = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPA.graph'));
    
    limits = [getAxisLimits(config,groundTruthCell);
              getAxisLimits(config,groundTruthCellS);
              getAxisLimits(config,resultsCell);
              getAxisLimits(config,resultsCellP);
              getAxisLimits(config,resultsCellPA);
              getAxisLimits(config,resultsCellSP);
              getAxisLimits(config,resultsCellSPA)];
    minLimits = min(limits(:,[1 3 5]));
    maxLimits = max(limits(:,[2 4 6]));
    range = maxLimits - minLimits;
    minLimits = minLimits.*(1 - 0.1*sign(minLimits));
    maxLimits = maxLimits.*(1 + 0.1*sign(maxLimits));
    axisLimits = [-8 8 -10 210 -2 12]; %default
%     axisLimits
    axisLimits([1 3 5]) = min(axisLimits([1 3 5]),minLimits);
    axisLimits([2 4 6]) = max(axisLimits([2 4 6]),maxLimits);
%     axisLimits

    %% 2. Plot Figure
%     set(0,'DefaultFigureWindowStyle','normal')
    h = figure; 
    set(h, 'units', 'centimeters', 'pos', [10 2 36 18])

    fontSize = 8;
    xt = -20:5:20;
    yt = -200:50:300;
    zt = -20:5:20;
    
    titleNC  = {'a) NoI'};
    titleP   = {'b) PI'};
    titlePA  = {'c) PAI'};
    titleSP  = {'d) Seg. PI'};
    titleSPA = {'e) Seg. PAI'};
    
    h1 = subplot(2,5,1);
    t1 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1,'FontSize',fontSize)
    set(h1,'XTick',xt)
    set(h1,'YTick',yt)
    set(h1,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])
    
    h2 = subplot(2,5,2);
    t2 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2,'FontSize',fontSize)
    set(h2,'XTick',xt)
    set(h2,'YTick',yt)
    set(h2,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h3 = subplot(2,5,3);
    t3 = title(titlePA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3,'FontSize',fontSize)
    set(h3,'XTick',xt)
    set(h3,'YTick',yt)
    set(h3,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    h4 = subplot(2,5,4);
    t4 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h4,'FontSize',fontSize)
    set(h4,'XTick',xt)
    set(h4,'YTick',yt)
    set(h4,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h5 = subplot(2,5,5);
    t5 = title(titleSPA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h5,'FontSize',fontSize)
    set(h5,'XTick',xt)
    set(h5,'YTick',yt)
    set(h5,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPA,[0 0 1])

    h6 = subplot(2,5,6);
    t6 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h6,'FontSize',fontSize)
    set(h6,'XTick',xt)
    set(h6,'YTick',yt)
    set(h6,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    h7 = subplot(2,5,7);
    t7 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h7,'FontSize',fontSize)
    set(h7,'XTick',xt)
    set(h7,'YTick',yt)
    set(h7,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h8 = subplot(2,5,8);
    t8 = title(titlePA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h8,'FontSize',fontSize)
    set(h8,'XTick',xt)
    set(h8,'YTick',yt)
    set(h8,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    h9 = subplot(2,5,9);
    t9 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h9,'FontSize',fontSize)
    set(h9,'XTick',xt)
    set(h9,'YTick',yt)
    set(h9,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h10 = subplot(2,5,10);
    t10 = title(titleSPA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h10,'FontSize',fontSize)
    set(h10,'XTick',xt)
    set(h10,'YTick',yt)
    set(h10,'ZTick',zt)
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
        imageName = strcat(imagePath,sep,'Trial_',num2str(i));
%         s=hgexport('readstyle','iros');
        print(h,imageName,'-dpng','-r600');
%         print(h,imageName,'-depsc','-painters','-r600')
%         print(h,imageName,'-dpdf','-painters','-bestfit')
        delete(h);
    end
end

