%% Figure 3 
%% Part B
clc;clear;close all
%% Find the folder path
paths = setupProject(pwd);  
addpath(paths.utils)
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%  Event Detection - B1 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure3_B1 = readtable(fullfile(paths.data,"Fig3_B_1.csv")); 
load(fullfile(paths.data,"LFPColorPLOT2.mat"));
%%  Accuracy 
AllPlot = [Figure3_B1.ACC_Session_LFP,Figure3_B1.ACC_Shuffle_LFP,...
    Figure3_B1.ACC_Session_MUAe,Figure3_B1.ACC_Shuffle_MUAe];
Label = [ones(51,1);2*ones(51,1);3*ones(51,1);4*ones(51,1)];

figure(1)
violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3 4])
xticklabels({'LFP','','MUAe',''})
yticks([50:10:100])
ylim([40 100])
title("Event Detection")
ylabel('Accuracy (%)')
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;

%% 
AllPlot2 = [Figure3_B1.Cohen_Session_LFP,Figure3_B1.Cohen_Shuffle_LFP,...
    Figure3_B1.Cohen_Session_MUAe, Figure3_B1.Cohen_Shuffle_MUAe];

figure(2)
violinplot(AllPlot2,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3 4])
xticklabels({'LFP','','MUAe',''})
yticks([0:0.2:1])
ylim([-0.1 0.9])
title("Event Detection")
ylabel('Cohen Kappa')
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%  Envelope Decoding - B2 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Figure3_B2 = readtable(fullfile(paths.data,"Fig3_B_2.csv")); 

%% 
AllPlot = [Figure3_B2.Corr_Session_LFP, Figure3_B2.Corr_Shuffle_LFP,...
    Figure3_B2.Corr_Session_MUAe, Figure3_B2.Corr_Shuffle_MUAe];
%% Correlation 
figure(3)
violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);

xticks([1 2 3 4])
xticklabels({'LFP','','MUAe',''})
yticks([0:0.2:1])
ylim([-0.1 0.8])
title("Envelope Decoding")
ylabel('Correlation (r)')
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;

%% R2
AllPlot2 = [Figure3_B2.R2_Session_LFP,Figure3_B2.R2_Shuffle_LFP,...
    Figure3_B2.R2_Session_MUAe, Figure3_B2.R2_Shuffle_MUAe];

figure(4)
violinplot(AllPlot2,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticklabels({'LFP','','MUAe',''})
yticks([0:0.2:0.7])
ylim([0 0.65])
ylabel("R^2")
title("Envelope Decoding")
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%  Landmarks Detection - B3 %%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Figure3_B3 = readtable(fullfile(paths.data,"Fig3_B_3.csv")); 

%% Peak Rate
AllPlot = [Figure3_B3.Acc_LFP_PeakRate,Figure3_B3.AccShuffle_LFP_PeakRate,...
    Figure3_B3.Acc_MUAe_PeakRate,Figure3_B3.AccShuffle_MUAe_PeakRate];
Label = [ones(51,1);2*ones(51,1);3*ones(51,1);4*ones(51,1)];

%% 
figure(5)
violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticklabels({'LFP','','MUAe',''})
yticks([10:20:70])
ylim([10 80])
ylabel("Accuracy (%)")
title("Peak Rate")
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;


%% Peak Envelope
AllPlot2 = [Figure3_B3.Acc_LFP_PeakEnv,Figure3_B3.AccShuffle_LFP_PeakEnv,...
    Figure3_B3.Acc_MUAe_PeakEnv,Figure3_B3.AccShuffle_MUAe_PeakEnv];

figure(6)
violinplot(AllPlot2,Label,'ViolinColor',[RP_Colors(1,:);[0.5,0.5,0.5];RP_Colors(3,:);[0.5,0.5,0.5]],...
    'ViolinAlpha',0.6,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticklabels({'LFP','','MUAe',''})
yticks([10:20:70])
ylim([10 80])
ylabel("Accuracy (%)")
title("Peak Envelope")
set(gca, 'linewidth', 0.5,'FontName','Arial','FontSize',14)
grid on
box off;
