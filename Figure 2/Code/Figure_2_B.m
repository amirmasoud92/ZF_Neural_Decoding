%% Figure 2 - Final 
%% Amirmasoud Ahmadi 
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%%  Event Detection Results %%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;close all;clear
paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Event Song Detection Final','Accuracy_EventDetection_AllSessions.mat'));
load(fullfile(paths.data,'Event Song Detection Final','Actual_StimuluiCat_AllSessions.mat'));
load(fullfile(paths.data,'Event Song Detection Final','CohenKappa_EventDetection_AllSessions.mat'));
load(fullfile(paths.data,'Event Song Detection Final','Predicted_StimuluiCat_AllSessions.mat'));
load(fullfile(paths.data,'Event Song Detection Final','StimW_Type.mat'));
load(fullfile(paths.data,'Event Song Detection Final','Event_Detect_Results_Table.mat')); 

%% 
NStim_Github = 1;
Stim_Wave = StimW_Type{NStim_Github};
[b,a] = butter(3,2*[100 5000]/25000,"bandpass");
Stim_Wave = filtfilt(b,a,Stim_Wave);
Stim_Wave = [zeros(5000,1);Stim_Wave;zeros(5000,1)];
Stim_Wave = Stim_Wave(1:2:end);
Time_Wave = (1:1:length(Stim_Wave))./12500; Time_Wave = Time_Wave-0.2;

%% Select Session and Trial
Session = 46;
TR = 52;
Actual = All_Acc_Stim{Session}{TR};
Time = (0:1:length(Actual)-1)./100; Time = Time-0.2;

Predicted = All_Pred_Stim{Session}{TR};
Time = (0:1:length(Actual)-1)./100; Time = Time-0.2;

AccAll = 100*length(find(Predicted==Actual))./length(Actual);

%% 

SI = find(Actual=="0");
AccSilent = 100*length(find(Predicted(SI)==Actual(SI)))./length(Actual(SI));
SI = find(Actual=="1");
AccSyll = 100*length(find(Predicted(SI)==Actual(SI)))./length(Actual(SI));

%% Figure 2
%% Event Detection 
figure(1)
p1 =plot(Time_Wave,10*Stim_Wave,'Color','#D9DADB','LineWidth',0.00001);
hold on 
p2 = stairs(Time,double(Actual)-1,'Color',"#80B3FF",'LineStyle','-','LineWidth',2.5);
hold on;
p3 = stairs(Time,1.05*(double(Predicted)-1),'Color',"#7E2F8E",'LineStyle',':','Marker','square','LineWidth',1.5,'MarkerEdgeColor',"#7E2F8E",'MarkerFaceColor',"#7E2F8E",'MarkerSize',1.5);

xlim([min(Time),max(Time)])
xlabel('Time from Stimulus Onset (s)','FontWeight','bold','FontName','Arial','FontSize',14)
legend([p2 p3],{'Actual State','Predicted State'},'FontName','Arial','FontWeight','bold','FontSize',18,'location','southeast')
yticks([0 1.02])
ylim([-1.5 1.5])
yticklabels({'Silent','Syllable'})

set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold')
box off;
title('Song Event Detection','FontName','Arial','FontWeight','bold','FontSize',30,'Color','#0E6655')
set(gcf,'Position',[500 500 1000 500])

fprintf(['Accuracy All = ',num2str(AccAll)])
fprintf('\n')
fprintf(['Accuracy Silent = ',num2str(AccSilent)])
fprintf('\n')
fprintf(['Accuracy Syllable = ',num2str(AccSyll)])
fprintf('\n')

%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%  %%%%%   Envelope Decoding %%%%%%%%%%%%%%%%%%
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear
paths = setupProject(pwd);  
addpath(paths.utils)

% ActualStim_All1 = importdata(fullfile(paths.data,'NarrowBand Song Final','ActualStimTest_All_Session.mat'));

ActualEnv = importdata(fullfile(paths.data,'NarrowBand Song Final','ActualStimPlot.mat')); 
Corr_All1 = importdata(fullfile(paths.data,'NarrowBand Song Final','CorrResults_All_Session.mat'));
NMSE_All1 = importdata(fullfile(paths.data,'NarrowBand Song Final','NMSEResults_All_Session.mat'));
Per_Out_All1 = importdata(fullfile(paths.data,'NarrowBand Song Final','PredictedStimTest_All_Session.mat'));
load(fullfile(paths.data,'NarrowBand Song Final','StimW_Type.mat'));

%% 
Session = 46;
Fold = 1;
Trialsss = 2;
% ActualEnv = ActualStim_All1{Session}{Fold}{Trialsss};
PredictEnv = Per_Out_All1{Session}{Fold}{Trialsss};
CorrPr  = Corr_All1{Session}{Fold}(Trialsss);

%%

mdl = fitlm(ActualEnv,PredictEnv);
R2_Perf = double(mdl.Rsquared.Adjusted);
Time = (0:length(ActualEnv)-1)./500;

%% 

NStim_Github = 1;
Stim_Wave = StimW_Type{NStim_Github};
[b,a] = butter(3,2*[100 5000]/25000,"bandpass");
Stim_Wave = filtfilt(b,a,Stim_Wave);
Stim_Wave = Stim_Wave(1:2:end);
Time_Wave = (1:1:length(Stim_Wave))./12500; 

%% 
figure(2)
p1 = plot(Time_Wave,Stim_Wave,'Color','#D9DADB','LineWidth',0.00001);
hold on 
p2 = plot(Time,ActualEnv,'Color',"#80B3FF",'LineStyle','-','LineWidth',2.5);
hold on 
p3 = plot(Time,PredictEnv,'Color',"#7E2F8E",'LineStyle','-','LineWidth',2.5);
hold on 
xlim([min(Time_Wave),max(Time_Wave)])

ylabel('Amplitude','FontName','Arial','FontSize',14)
xlabel('Time from Stimulus Onset (s)','FontName','Arial','FontSize',14)

legend([p2 p3],{'Actual Envelope','Predicted Envelope'},'FontName','Arial','FontWeight','bold','FontSize',18,'location','southeast')
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold')
box off;

title('Narrow-Band Envelope Decoding','FontName','Arial','FontWeight','bold','FontSize',30,'Color','#0E6655')
set(gcf,'Position',[500 500 1000 500])

fprintf(['Corr All = ',num2str(Corr_All1{46}{1}(2))])
fprintf('\n')
fprintf(['R2_Adjusted = ',num2str(R2_Perf)])
fprintf('\n')


%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Envelope Landmark Detection
%%  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear
paths = setupProject(pwd);  
addpath(paths.utils)

Cohen_All = importdata(fullfile(paths.data,'Env Feature Detect Final','CohenResults_All_Session.mat'));
ActualEnv_Feature = importdata(fullfile(paths.data,'Env Feature Detect Final','ActualStimTest_All_Session.mat'));
Predicted_Feature = importdata(fullfile(paths.data,'Env Feature Detect Final','PredictedStimTest_All_Session.mat'));
Confusion_All = importdata(fullfile(paths.data,'Env Feature Detect Final','Confusion_Folds_All_Session.mat'));
load(fullfile(paths.data,'Env Feature Detect Final','StimW_Type.mat'));

%% 
NStim_Github = 1;
Stim_Wave = StimW_Type{NStim_Github};
[b,a] = butter(3,2*[100 5000]/25000,"bandpass");
Stim_Wave = filtfilt(b,a,Stim_Wave);
Stim_Wave = Stim_Wave(1:2:end);
Time_Wave = (1:1:length(Stim_Wave))./12500; 

%%
Session = 46;
Trial = 19;
ActualSelect = double(ActualEnv_Feature{Session}{Trial})-1;ActualSelect(find(ActualSelect==0))=nan;
PredictSelect = double(Predicted_Feature{Session}{Trial})-1;PredictSelect(find(PredictSelect==0))=nan;
TimePP = (0:length(ActualSelect)-1)/50;

CSelect = Cohen_All{Session}(Trial);
A = find(ActualSelect==1);
ACCRATE = length(find(ActualSelect(A)==PredictSelect(A)))./length(ActualSelect(A));
A = find(ActualSelect==2);
ACCEnv = length(find(ActualSelect(A)==PredictSelect(A)))./length(ActualSelect(A));


fprintf(['Acc.P. Rate = ',num2str(100*ACCRATE)])
fprintf('\n')
fprintf(['Acc.P. Env = ',num2str(100*ACCEnv)])
fprintf('\n')
fprintf(['Cohen Kappa = ',num2str(Cohen_All{46}(19))])
fprintf('\n')

%%
figure(3)
p1 = plot(Time_Wave,Stim_Wave./max(Stim_Wave),'Color','#D9DADB','LineWidth',0.00001);
hold on
[A,ylower] = envelope(Stim_Wave,500,'rms');
p2 = plot(Time_Wave,A./max(A),'Color','#55606A','LineWidth',2);
hold on
p3 = stem(TimePP,ActualSelect,'filled','-^','Color','#80B3FF','LineWidth',1);
hold on
p4 = stem(TimePP,PredictSelect*1.1,'filled','-.d','Color','#7E2F8E','LineWidth',1);

xlim([Time_Wave(1) Time_Wave(end)])
yticks([1 2]);
xticks([0 0.5 1 1.5 2])
yticklabels({'P.Rate','P.Env'})
xlabel('Time from Stimulus Onset (s)','FontName','Arial','FontSize',14)
legend([p3 p4],{'Actual Landmarks','Predicted Landmarks'},'FontName','Arial','FontWeight','bold','FontSize',16,'location','southeast')
set(gca, 'FontSize', 16,'FontName','Arial','FontWeight','bold')
box off;
title('Envelope Landmark Detection','FontName','Arial','FontWeight','bold','FontSize',30,'Color','#0E6655')
set(gcf,'Position',[500 500 1000 500])
grid on









