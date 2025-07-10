%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%% Event Detection %%%%%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%  LFP %%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all

paths = setupProject(pwd);
addpath(paths.utils)


Data = readtable(fullfile(paths.data,'S12', 'FigS12_Event_LFP.csv')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))

%%
Intro = Data.Intro_Perf; 
Motif1 = Data.Motif1_Perf; 
Motif2 = Data.Motif2_Perf; 
%% 
AllPlot = [Intro,Motif1,Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];
%%
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
hold on
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
yticks([0:0.2:0.9])
ylabel('Kappa Value','FontSize',12,'FontWeight','bold','FontName','Arial')
title('LFP Singals | Event Detection','FontSize',14,'FontWeight','bold','FontName','Arial')
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%% Event Detection %%%%%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%  MUAe %%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;

paths = setupProject(pwd);
addpath(paths.utils)


Data = readtable(fullfile(paths.data,'S12', 'FigS12_Event_MUAe.csv')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))


%%
Intro = Data.Intro_Perf; 
Motif1 = Data.Motif1_Perf; 
Motif2 = Data.Motif2_Perf; 
%% 
AllPlot = [Intro,Motif1,Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];
%%
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
hold on
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
title('MUAe Singals | Event Detection','FontSize',14,'FontWeight','bold','FontName','Arial')
ylabel('Kappa Value','FontSize',12,'FontWeight','bold','FontName','Arial')
yticks([0:0.2:0.9])
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%% Envelope Decoding %%%%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%  LFP %%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;

paths = setupProject(pwd);
addpath(paths.utils)


Data = readtable(fullfile(paths.data,'S12', 'FigS12_Envelope_LFP.csv')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))

%%
Intro = Data.Intro_Perf; 
Motif1 = Data.Motif1_Perf; 
Motif2 = Data.Motif2_Perf; 
%% 
AllPlot = [Intro,Motif1,Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];

%% 
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
yticks([0:0.2:0.8])
ylabel('Correlation','FontSize',12,'FontWeight','bold','FontName','Arial')
title('LFP Singals | Envelope Decoding','FontSize',14,'FontWeight','bold','FontName','Arial')
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%% Envelope Decoding %%%%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%  MUAe %%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;

paths = setupProject(pwd);
addpath(paths.utils)

Data = readtable(fullfile(paths.data,'S12', 'FigS12_Envelope_MUAe.csv')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))

%%
Intro = Data.Intro_Perf; 
Motif1 = Data.Motif1_Perf; 
Motif2 = Data.Motif2_Perf; 
%% 
AllPlot = [Intro,Motif1,Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];

%% 
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
yticks([0:0.2:0.8])
ylabel('Correlation','FontSize',12,'FontWeight','bold','FontName','Arial')
title('MUAe Singals | Envelope Decoding','FontSize',14,'FontWeight','bold','FontName','Arial')
grid on
box off;


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%% Envelope Landmarks %%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%% LFP %%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;

paths = setupProject(pwd);
addpath(paths.utils)

Data = importdata(fullfile(paths.data,'S12', 'FigS12_LFP_Landmarks.mat')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))

%%
Intro = Data(:,1); 
Motif1 = Data(:,2); 
Motif2 = Data(:,3); 
%% 
AllPlot = [Intro;Motif1;Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];

%% 
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
yticks([0:0.2:0.8])
ylabel('Kappa Value','FontSize',12,'FontWeight','bold','FontName','Arial')
title('LFP Singals | Landmarks Detection','FontSize',14,'FontWeight','bold','FontName','Arial')
grid on
box off;

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%% Envelope Landmarks %%%%%% 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%% MUAe %%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;

paths = setupProject(pwd);
addpath(paths.utils)

Data = readtable(fullfile(paths.data,'S12', 'FigS12_Landmark_MUAe.csv')); 

load(fullfile(paths.data,'S12', 'LFPColorPLOT2.mat'))

%%
Intro = Data.Intro_Perf; 
Motif1 = Data.Motif1_Perf; 
Motif2 = Data.Motif2_Perf; 
%% 
AllPlot = [Intro,Motif1,Motif2];
Label = [ones(length(Intro),1);2*ones(length(Motif1),1);3*ones(length(Motif2),1)];

%% 
figure()
for i = 1:length(Intro)
    plot([1 2 3],[Intro(i),  Motif1(i),    Motif2(i)], ...
        'Color','#DEDCDE','LineWidth',0.1)
    hold on
end

violinplot(AllPlot,Label,'ViolinColor',[RP_Colors(1,:);RP_Colors(6,:);RP_Colors(3,:)],...
    'ViolinAlpha',0.7,'EdgeColor',[0.5,0.5,0.5],'BoxColor',[0 0 0],'MedianColor',[0 0 0],'ShowMean',true);
xticks([1 2 3])
xticklabels({'Intro','Motif 1','Motif 2'})
yticks([0:0.2:0.8])
title('MUAe Singals | Landmarks Detection','FontSize',14,'FontWeight','bold','FontName','Arial')
ylabel('Kappa Value','FontSize',12,'FontWeight','bold','FontName','Arial')
grid on
box off;