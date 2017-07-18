clear all
clear classes
% close all
addpath(genpath(pwd))

%% 1. Load
saveFigures = 1;
experimentPath = 'Experiment_14_PlanarAngularInfo';

trials = [2,14,20,21,26,27,28,30,31,37,38,39,40,41,42,44,45,47,50,...
     51,55,57,59,65,67,69,72,75,79,80,101,106,112,116,117,118,119,120,122,...
     132,133,134,139,142,144,145,147,149,152,153,154,155,158,159];

 for i = 1:length(trials)
     
    fprintf('\nTrial: %d\n',trials(i))
    
    if ispc; sep = '\'; elseif isunix || ismac; sep = '/'; end 
    trialFilePath = strcat(experimentPath,sep,'Trial_',num2str(trials(i)));
    load(strcat('Data',sep,'GraphFiles',sep,trialFilePath,sep,'config.mat'))
    config.savePath = pwd; %loaded configs might not have same path

    groundTruthCell  = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruth.graph'),'noConstraints');
    groundTruthCellS = graphFileToCell(config,strcat(trialFilePath,sep,'groundTruthS.graph'));
    
    resultsCell    = graphFileToCell(config,strcat(trialFilePath,sep,'results.graph'));
    resultsCellP   = graphFileToCell(config,strcat(trialFilePath,sep,'resultsP.graph'));
    resultsCellPA  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPA.graph'));
    resultsCellPANoC  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPANoC.graph'));
    resultsCellPAPC  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsPAPC.graph'));
    resultsCellSP  = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSP.graph'));
    resultsCellSPA = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPA.graph'));
    resultsCellSPANoC = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPANoC.graph'));
    resultsCellSPASPC = graphFileToCell(config,strcat(trialFilePath,sep,'resultsSPASPC.graph'));
    
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
    h1 = figure; 
    set(h1, 'units', 'centimeters', 'pos', [10 2 36 18])

    fontSize = 8;
    xt = -20:5:20;
    yt = -200:50:300;
    zt = -20:5:20;
    
    titleNC  = {'a) NoI'};
    titleP   = {'b) PI'};
    titlePA  = {'c) PAI'};
    titleSP  = {'d) Seg. PI'};
    titleSPA = {'e) Seg. PAI'};
    
    h1_1 = subplot(2,5,1);
    t1_1 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1_1,'FontSize',fontSize)
    set(h1_1,'XTick',xt)
    set(h1_1,'YTick',yt)
    set(h1_1,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])
    
    h1_2 = subplot(2,5,2);
    t1_2 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1_2,'FontSize',fontSize)
    set(h1_2,'XTick',xt)
    set(h1_2,'YTick',yt)
    set(h1_2,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h1_3 = subplot(2,5,3);
    t1_3 = title(titlePA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1_3,'FontSize',fontSize)
    set(h1_3,'XTick',xt)
    set(h1_3,'YTick',yt)
    set(h1_3,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    h1_4 = subplot(2,5,4);
    t1_4 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1_4,'FontSize',fontSize)
    set(h1_4,'XTick',xt)
    set(h1_4,'YTick',yt)
    set(h1_4,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h1_5 = subplot(2,5,5);
    t1_5 = title(titleSPA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h1_5,'FontSize',fontSize)
    set(h1_5,'XTick',xt)
    set(h1_5,'YTick',yt)
    set(h1_5,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPA,[0 0 1])

    h1_6 = subplot(2,5,6);
    t1_6 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h1_6,'FontSize',fontSize)
    set(h1_6,'XTick',xt)
    set(h1_6,'YTick',yt)
    set(h1_6,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    h1_7 = subplot(2,5,7);
    t1_7 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h1_7,'FontSize',fontSize)
    set(h1_7,'XTick',xt)
    set(h1_7,'YTick',yt)
    set(h1_7,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h1_8 = subplot(2,5,8);
    t1_8 = title(titlePA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h1_8,'FontSize',fontSize)
    set(h1_8,'XTick',xt)
    set(h1_8,'YTick',yt)
    set(h1_8,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPA,[0 0 1])

    h1_9 = subplot(2,5,9);
    t1_9 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h1_9,'FontSize',fontSize)
    set(h1_9,'XTick',xt)
    set(h1_9,'YTick',yt)
    set(h1_9,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h1_10 = subplot(2,5,10);
    t1_10 = title(titleSPA,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h1_10,'FontSize',fontSize)
    set(h1_10,'XTick',xt)
    set(h1_10,'YTick',yt)
    set(h1_10,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPA,[0 0 1])

    titleCell = {'Comparison',...
                [' (rngSeed = ',num2str(config.rngSeed,3),...
                ', sigmaOdometry = ',mat2str(config.stdPosePose',3)],...
                [', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
    suptitle(titleCell)
    
    % 2nd image of same trial
    h2 = figure; 
    set(h2, 'units', 'centimeters', 'pos', [10 2 36 18])

    fontSize = 8;
    xt = -20:5:20;
    yt = -200:50:300;
    zt = -20:5:20;
    
    titleNC  = {'a) NoI'};
    titleP   = {'b) PI'};
    titlePANoC  = {'c) PAI starting NoI'};
    titleSP  = {'d) Seg. PI'};
    titleSPANoC = {'e) Seg. PAI starting NoI'};
    
    h2_1 = subplot(2,5,1);
    t2_1 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2_1,'FontSize',fontSize)
    set(h2_1,'XTick',xt)
    set(h2_1,'YTick',yt)
    set(h2_1,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])
    
    h2_2 = subplot(2,5,2);
    t2_2 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2_2,'FontSize',fontSize)
    set(h2_2,'XTick',xt)
    set(h2_2,'YTick',yt)
    set(h2_2,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h2_3 = subplot(2,5,3);
    t2_3 = title(titlePANoC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2_3,'FontSize',fontSize)
    set(h2_3,'XTick',xt)
    set(h2_3,'YTick',yt)
    set(h2_3,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPANoC,[0 0 1])

    h2_4 = subplot(2,5,4);
    t2_4 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2_4,'FontSize',fontSize)
    set(h2_4,'XTick',xt)
    set(h2_4,'YTick',yt)
    set(h2_4,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h2_5 = subplot(2,5,5);
    t2_5 = title(titleSPANoC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h2_5,'FontSize',fontSize)
    set(h2_5,'XTick',xt)
    set(h2_5,'YTick',yt)
    set(h2_5,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPANoC,[0 0 1])

    h2_6 = subplot(2,5,6);
    t2_6 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h2_6,'FontSize',fontSize)
    set(h2_6,'XTick',xt)
    set(h2_6,'YTick',yt)
    set(h2_6,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    h2_7 = subplot(2,5,7);
    t2_7 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h2_7,'FontSize',fontSize)
    set(h2_7,'XTick',xt)
    set(h2_7,'YTick',yt)
    set(h2_7,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h2_8 = subplot(2,5,8);
    t2_8 = title(titlePANoC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h2_8,'FontSize',fontSize)
    set(h2_8,'XTick',xt)
    set(h2_8,'YTick',yt)
    set(h2_8,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPANoC,[0 0 1])

    h2_9 = subplot(2,5,9);
    t2_9 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h2_9,'FontSize',fontSize)
    set(h2_9,'XTick',xt)
    set(h2_9,'YTick',yt)
    set(h2_9,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h2_10 = subplot(2,5,10);
    t2_10 = title(titleSPANoC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h2_10,'FontSize',fontSize)
    set(h2_10,'XTick',xt)
    set(h2_10,'YTick',yt)
    set(h2_10,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPANoC,[0 0 1])
    
    
    titleCell = {'Comparison',...
                [' (rngSeed = ',num2str(config.rngSeed,3),...
                ', sigmaOdometry = ',mat2str(config.stdPosePose',3)],...
                [', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
    suptitle(titleCell)
    
    % 3rd image of same trial
    h3 = figure; 
    set(h3, 'units', 'centimeters', 'pos', [10 2 36 18])

    fontSize = 8;
    xt = -20:5:20;
    yt = -200:50:300;
    zt = -20:5:20;
    
    titleNC  = {'a) NoI'};
    titleP   = {'b) PI'};
    titlePAPC  = {'c) PAI starting PI'};
    titleSP  = {'d) Seg. PI'};
    titleSPASPC = {'e) Seg. PAI starting Seg. PI'};
    
    h3_1 = subplot(2,5,1);
    t3_1 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3_1,'FontSize',fontSize)
    set(h3_1,'XTick',xt)
    set(h3_1,'YTick',yt)
    set(h3_1,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])
    
    h3_2 = subplot(2,5,2);
    t3_2 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3_2,'FontSize',fontSize)
    set(h3_2,'XTick',xt)
    set(h3_2,'YTick',yt)
    set(h3_2,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h3_3 = subplot(2,5,3);
    t3_3 = title(titlePAPC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3_3,'FontSize',fontSize)
    set(h3_3,'XTick',xt)
    set(h3_3,'YTick',yt)
    set(h3_3,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPAPC,[0 0 1])

    h3_4 = subplot(2,5,4);
    t3_4 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3_4,'FontSize',fontSize)
    set(h3_4,'XTick',xt)
    set(h3_4,'YTick',yt)
    set(h3_4,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h3_5 = subplot(2,5,5);
    t3_5 = title(titleSPASPC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view(config.plotView)
    xlabel('x')
    ylabel('y','rot',0)
    zlabel('z')
    set(h3_5,'FontSize',fontSize)
    set(h3_5,'XTick',xt)
    set(h3_5,'YTick',yt)
    set(h3_5,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPASPC,[0 0 1])

    h3_6 = subplot(2,5,6);
    t3_6 = title(titleNC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h3_6,'FontSize',fontSize)
    set(h3_6,'XTick',xt)
    set(h3_6,'YTick',yt)
    set(h3_6,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCell,[0 0 1])

    h3_7 = subplot(2,5,7);
    t3_7 = title(titleP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h3_7,'FontSize',fontSize)
    set(h3_7,'XTick',xt)
    set(h3_7,'YTick',yt)
    set(h3_7,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellP,[0 0 1])

    h3_8 = subplot(2,5,8);
    t3_8 = title(titlePAPC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h3_8,'FontSize',fontSize)
    set(h3_8,'XTick',xt)
    set(h3_8,'YTick',yt)
    set(h3_8,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCell,[1 0 0]);
    plotGraphFile(config,resultsCellPAPC,[0 0 1])

    h3_9 = subplot(2,5,9);
    t3_9 = title(titleSP,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h3_9,'FontSize',fontSize)
    set(h3_9,'XTick',xt)
    set(h3_9,'YTick',yt)
    set(h3_9,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSP,[0 0 1])

    h3_10 = subplot(2,5,10);
    t3_10 = title(titleSPASPC,'FontSize',fontSize,'FontWeight','normal');
    if config.axisEqual; axis equal; end
%     axis square
    axis(axisLimits)
    view([90 0])
    xlabel('x')
    ylabel('y')
    zlabel('z','rot',0)
    set(h3_10,'FontSize',fontSize)
    set(h3_10,'XTick',xt)
    set(h3_10,'YTick',yt)
    set(h3_10,'ZTick',zt)
    hold on
    plotGraphFile(config,groundTruthCellS,[1 0 0]);
    plotGraphFile(config,resultsCellSPASPC,[0 0 1])
    
    
    titleCell = {'Comparison',...
                [' (rngSeed = ',num2str(config.rngSeed,3),...
                ', sigmaOdometry = ',mat2str(config.stdPosePose',3)],...
                [', sigmaPoint = ',mat2str(config.stdPosePoint',3),...
                ', sigmaPlanar = ',mat2str(config.stdPointPlane',3),...
                ', sigmaAngle = ',mat2str(config.stdPlanePlaneAngle',3),')']};
    suptitle(titleCell)

    %% 3. Export Figure
    if saveFigures
        image1Path = strcat(config.savePath,sep,'Data',sep,'GraphFiles',sep,experimentPath,sep,'Figures');
        if ~exist(image1Path,'dir'); mkdir(image1Path); end;
        image1Name = strcat(image1Path,sep,'Trial_',num2str(trials(i)),'_1');
%         s=hgexport('readstyle','iros');
        print(h1,image1Name,'-dpng','-r600');
        delete(h1);
        
        image2Path = strcat(config.savePath,sep,'Data',sep,'GraphFiles',sep,experimentPath,sep,'Figures');
        if ~exist(image2Path,'dir'); mkdir(image2Path); end;
        image2Name = strcat(image2Path,sep,'Trial_',num2str(trials(i)),'_2');
%         s=hgexport('readstyle','iros');
        print(h2,image2Name,'-dpng','-r600');
        delete(h2);
        
        image3Path = strcat(config.savePath,sep,'Data',sep,'GraphFiles',sep,experimentPath,sep,'Figures');
        if ~exist(image3Path,'dir'); mkdir(image3Path); end;
        image3Name = strcat(image3Path,sep,'Trial_',num2str(trials(i)),'_3');
%         s=hgexport('readstyle','iros');
        print(h3,image3Name,'-dpng','-r600');
        delete(h3);
    end
end

