%% Figure S9 - MUA Across Recording Sessions with Varied Decoding Performance Levels.
%% Load Data
clc;clear;close all;
paths = setupProject(pwd);
addpath(paths.utils)

SUA_All = importdata(fullfile(paths.data,'S9','Spike_Times_Neurons.mat'));
Stim_Len = importdata(fullfile(paths.data,'S9','StimAll_Length.mat'));
Playback_L = importdata(fullfile(paths.data,'S9','Playback_Label_All_Neurons.mat'));
NeuronsD = readtable(fullfile(paths.data,'S9','Neurons_Detail.xlsx'));

load(fullfile(paths.data,'S9','StimW_Type.mat'));
load(fullfile(paths.data,'S9','LFPColorPLOT2.mat')); 
load(fullfile(paths.data,'S9','MUAe_NarrowBand_Decoding_Results_Table_New4.mat'));

Bird_Name = 'All_Birds.mat';

%%
window_size = 0.01;
shift = 0.01;
normal = 0;
SmoothIOpt = 1;

N_Session = NeuronsD.SessionNumber;
clear MUA_Activity Time_Activity

for i = 1:51

    A = find(N_Session==i);
    SU_Session = SUA_All(A);
    sequenceLengths = cellfun(@(x) size(x,2), SU_Session);
    NTrial = mode(sequenceLengths);
    UnitSession = SU_Session(find(sequenceLengths==NTrial));
    P_Label = Playback_L{A(1)};

    UnitSessionAll = [];
    for j = 1: length(UnitSession)
        UnitSessionAll = [UnitSessionAll,UnitSession{j}'];
    end

    %% Plot Normalize FR each Unit
    for Song = 1:10
        time_window = [-0.5 Stim_Len(Song)+0.5];
        AA = find(P_Label==Song); A = UnitSessionAll(AA,:);
        SpikeAA = cell2mat(A(:)');

        FR_ALL = FR_Amir_MUA_S10(SpikeAA, window_size, shift, time_window, normal,SmoothIOpt,length(AA));
        MUA_Activity{Song}(i,:) = FR_ALL(:,2);
        Time_Activity{Song}(i,:) = FR_ALL(:,1);
    end

end


%% Sessions Results
AccuracyTrials = NarrowBand_Decoding_NewFormat.Performance;
MeanAcc_Session = [];

for i = 1:51
    A =  find(NarrowBand_Decoding_NewFormat.Session_Number==i);
    MeanAcc_Session(i) = mean(AccuracyTrials(A));
end

%%
[SortedAcc, IndxAcc] = sort(MeanAcc_Session);
LowAccSession = IndxAcc(1:11); LowAccSession(3) = [];
HighAccSession = IndxAcc(end-10:end); HighAccSession(8) = [];
MidAcc_Session = IndxAcc(21:30);
%% S10
clear MUA_Act_LowMidHigh

for i = 1:10
    MUA_Act_LowMidHigh{1, i} = MUA_Activity{i}(LowAccSession,:);
    MUA_Act_LowMidHigh{2, i} = MUA_Activity{i}(MidAcc_Session,:);
    MUA_Act_LowMidHigh{3, i} = MUA_Activity{i}(HighAccSession,:);
end

%%

figure()
tiledlayout(3,4,"TileSpacing","loose")

for i = 1:10

    time = [0:length(StimW_Type{i})-1]./25000;

    nexttile

    %% Low Accuracy Sessions

    MeanFR_Min_Acc = nanmean(MUA_Activity{i}(LowAccSession,:));
    plot(Time_Activity{i}(1,:),MeanFR_Min_Acc,'r','LineWidth',2);
    xlim([Time_Activity{i}(1,1),Time_Activity{i}(1,end)])
    box off; hold on;
    Max_FR_Low = max(MeanFR_Min_Acc);
    yticks([-1 0 1 2])
    
    %% High Accuracy Sessions

    hold on
    MeanFR_High_Acc = nanmean(MUA_Activity{i}(HighAccSession,:));
    plot(Time_Activity{i}(1,:), MeanFR_High_Acc,'Color','#34495e','LineWidth',2);
    xlim([Time_Activity{i}(1,1),Time_Activity{i}(1,end)])
    box off; hold on;
    Max_FR_High = max(MeanFR_High_Acc);
    yticks([-1 0 1 2])

    %% Mid Acc
    hold on
    MeanFR_Mid_Acc = nanmean(MUA_Activity{i}(MidAcc_Session,:));

    plot(Time_Activity{i}(1,:), MeanFR_Mid_Acc,'Color','#af7ac5','LineWidth',1.5);
    xlim([Time_Activity{i}(1,1),Time_Activity{i}(1,end)])
    Max_FR_Mid = max(MeanFR_Mid_Acc);
    %% Maximum FR all cases
    Max_All =  max([MeanFR_Min_Acc, MeanFR_High_Acc, MeanFR_Mid_Acc]);

    box off; hold on;

    %% Plot Song Stimulus
    SS = Max_All+10+ double(20*StimW_Type{i}./max(StimW_Type{i}));
    plot(time, SS,'Color',[0.5 0.5 0.5])

    yticks([0:round(Max_All./10):Max_All])
    grid on
    title(['Song ',num2str(i)],'FontSize',20,'Color','#1a5276','FontWeight','bold','FontName','Arial')
    xlabel(['Time from Stimulus Onset'],'FontSize',14,'FontWeight','bold')
    ylabel(['Firing Rate (Hz)'],'FontSize',14,'FontWeight','bold')
    ylim([0 Max_All+35])

end

nexttile
plot([0,0],[0.1 0.1],'Color','#34495e','LineWidth',10);hold on
plot([0,0],[0.1 0.1],'Color','#af7ac5','LineWidth',10);hold on
plot([0,0],[0.1 0.1],'r','LineWidth',10);hold on
axis off
legend({'High Performance Sessions','Mid Performance Sessions', 'Low Performance Sessions'},...
    'Location','west','NumColumns',1,'FontSize',24,'FontWeight','bold')
