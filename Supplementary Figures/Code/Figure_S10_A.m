clc;clear all;close all

paths = setupProject(pwd);
addpath(paths.utils)

load(fullfile(paths.data,'S10','ITPCZ_FreqPlot.mat'))
load(fullfile(paths.data,'S10','ITPCZ_Sessions_All.mat'))
load(fullfile(paths.data,'S10','Accuracy_EventDetection_AllSessions.mat'))
load(fullfile(paths.data,'S10','StimW_Type.mat'))
load(fullfile(paths.data,'S10','New_OrderNumber_Name.mat'))
load(fullfile(paths.data,'S10','MeanAcc_Stim_SessionITPC.mat'))


Mean_Acc_S = arrayfun(@(x) mean(x{1}), All_AccF);
Mean_Acc_New = Mean_Acc_S(N_Order_New);
Order = N_Order_Birds(N_Order_New);
BN = {'F1','M1','F2','M2','F3','M3','M4'};

for i = 4 %% Bird Number

    A = find(strcmp(N_Order_Birds,BN(i)));
    Acc = Mean_Acc_New(A);
    N_Bird = N_Order_New(A);
    [SA,IDX] = sort(Acc);

    for j = 1 %% Song Number

        High_Acc_ITPCz = ITPCZ_Session{N_Bird(IDX(end))}{j};
        Stim = StimW_Type{j}./max(StimW_Type{j});

        figure()
        time = (0:size(High_Acc_ITPCz,2)-1)./1000; time = time-1;
        p1 = contour(time,FreqAll,High_Acc_ITPCz,'LineStyle','none','LineColor',[0 0 0],'Fill','on');
        hold on
        plot(zeros(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        timeS = (0:length(Stim)-1)/25000;
        hold on
        plot(max(timeS)*ones(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        Time_Wave = (0:length(Stim)-1)./25000;
        [Amp,ylower] = envelope(Stim,500,'rms');
        Amp = Amp./max(Amp);
        plot(Time_Wave,100+abs(min(20*Stim))+20*Stim,'Color','#d5dbdb','LineWidth',1)
        hold on
        plot(Time_Wave,100+abs(min(20*Stim))+20*Amp,'Color','#512e5f','LineWidth',2)
        yticks([5 20:20:100]);
        xlabel('Time (s)','FontName','Arial','FontWeight','normal','FontSize',16);
        ylabel('Frequency (Hz)','FontName','Arial','FontWeight','normal','FontSize',16);
        title([' Mean Accuracy: ',num2str(round(100*MeanAcc_Stim_Session{N_Bird(IDX(end))}(j))),'%'],'FontName','Arial','FontWeight','bold','Color','k','FontSize',18)
        clim([0 8])
        colormap jet

        grid on

        Mid_Acc_ITPCz = ITPCZ_Session{N_Bird(IDX(round(length(IDX)./2)))}{j};

        figure()

        time = (0:size(Mid_Acc_ITPCz,2)-1)./1000; time = time-1;
        p1 = contour(time,FreqAll,Mid_Acc_ITPCz,'LineStyle','none','LineColor',[0 0 0],'Fill','on');
        hold on
        plot(zeros(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        timeS = (0:length(StimW_Type{j})-1)/25000;
        hold on
        plot(max(timeS)*ones(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        Time_Wave = (0:length(Stim)-1)./25000;
        [Amp,ylower] = envelope(Stim,500,'rms');
        Amp = Amp./max(Amp);
        plot(Time_Wave,100+abs(min(20*Stim))+20*Stim,'Color','#d5dbdb','LineWidth',1)
        hold on
        plot(Time_Wave,100+abs(min(20*Stim))+20*Amp,'Color','#512e5f','LineWidth',2)
        yticks([5 20:20:100]);
        xlabel('Time (s)','FontName','Arial','FontWeight','normal','FontSize',16);
        ylabel('Frequency (Hz)','FontName','Arial','FontWeight','normal','FontSize',16);
        title([' Mean Accuracy: ',num2str(round(100*MeanAcc_Stim_Session{N_Bird(IDX(round(length(IDX)./2)))}(j))),'%'],'FontName','Arial','FontWeight','bold','Color','k','FontSize',18)
        clim([0 8])
        colormap jet
        grid on
        
        %%
        Low_Acc_ITPCz = ITPCZ_Session{N_Bird(IDX(2))}{j};
        AccLowwP = round(100*MeanAcc_Stim_Session{N_Bird(IDX(2))}(j));

        figure()
        time = (0:size(Low_Acc_ITPCz,2)-1)./1000; time = time-1;
        p2 = contour(time,FreqAll,Low_Acc_ITPCz,'LineStyle','none','LineColor',[0 0 0],'Fill','on');
        hold on
        plot(zeros(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        plot(max(timeS)*ones(1,length(FreqAll(1):FreqAll(end))),FreqAll(1):FreqAll(end),'LineWidth',5,'LineStyle','-','Color','#800000')
        hold on
        Time_Wave = (0:length(Stim)-1)./25000;
        [Amp,ylower] = envelope(Stim,500,'rms');
        Amp = Amp./max(Amp);
        plot(Time_Wave,100+abs(min(20*Stim))+20*Stim,'Color','#d5dbdb','LineWidth',1)
        hold on
        plot(Time_Wave,100+abs(min(20*Stim))+20*Amp,'Color','#512e5f','LineWidth',2)
        yticks([5 20:20:100]);
        xlabel('Time (s)','FontName','Arial','FontWeight','normal','FontSize',16);
        ylabel('Frequency (Hz)','FontName','Arial','FontWeight','normal','FontSize',16);
        title([' Mean Accuracy: ',num2str(AccLowwP),'%'],'FontName','Arial','FontWeight','bold','Color','k','FontSize',18)
        clim([0 8])
        colormap jet
    end
end

