%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%  Figure 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;close all;clear
paths = setupProject(pwd);  
addpath(paths.utils)

%% Clustering Results
load(fullfile(paths.data,'All_Activity.mat'))
load(fullfile(paths.data,'Idx_Cluster.mat'))
load(fullfile(paths.data,'map_SUA_Net.mat'))
load(fullfile(paths.data,'Neurons_Number_Mix.mat'))
load(fullfile(paths.data,'WaveClust_All.mat'))
load(fullfile(paths.data,'Map_All_3.mat'))

%% Figure 7 - A
figure(1)
scatter(Map_SUA_Net(:,1),Map_SUA_Net(:,2),[],[ones(400,1);2*ones(423,1)],'filled','o')
colormap jet
xlabel('tSNE-1','FontSize',12,'FontWeight','bold'); ylabel('tSNE-1','FontSize',12,'FontWeight','bold');
xticks({}); yticks({});

%% Figure 7 - B
figure(2)
II = find(Idx_Cluster<1);
Map_SUA_Net(II,1) = NaN;  Map_SUA_Net(II,2) = NaN; 
scatter(Map_SUA_Net(:,1),Map_SUA_Net(:,2),[],Idx_Cluster,"filled")
colormap jet
xlabel('tSNE-1','FontSize',12,'FontWeight','bold'); ylabel('tSNE-1','FontSize',12,'FontWeight','bold');
xticks({}); yticks({});

%% Figure 7 - C
figure(3)

subplot(3,1,1)
time = (1:size(WaveClust,3))./500;
plot(time,squeeze(WaveClust(1,1,:)),'LineWidth',2,'LineStyle','-','Color','k')
hold on 
plot(time,squeeze(WaveClust(1,2,:)),'LineWidth',2,'LineStyle','-.','Color','r')
xlim([time(1),time(end)])
xlabel('Time from stimulus onset')
ylabel('Normalized Activity')
box off

subplot(3,1,2)
time = (1:size(WaveClust,3))./500;
plot(time,squeeze(WaveClust(2,1,:)),'LineWidth',2,'LineStyle','-','Color','k')
hold on 
plot(time,squeeze(WaveClust(2,2,:)),'LineWidth',2,'LineStyle','-.','Color','r')
xlim([time(1),time(end)])
xlabel('Time from stimulus onset')
ylabel('Normalized Activity')
box off

subplot(3,1,3)
time = (1:size(WaveClust,3))./500;
plot(time,squeeze(WaveClust(3,1,:)),'LineWidth',2,'LineStyle','-','Color','k')
hold on 
plot(time,squeeze(WaveClust(3,2,:)),'LineWidth',2,'LineStyle','-.','Color','r')
xlim([time(1),time(end)])
xlabel('Time from stimulus onset')
ylabel('Normalized Activity')
box off

%% 
load(fullfile(paths.data,"SU_Info_All.mat"))


Depths = NeuronsD.Depth;
Channels = NeuronsD.RecordingChannel; 
Session_All = NeuronsD.SessionNumber;

%% 3D Spatial Map 

%% Cluster 1
%% 3D Spatial Map 

Cluster_Real = 0.001* ones(51,15);

for i = 1:length(Neurons_Number{1})
    
    NN = Neurons_Number{1}(i);
    Cluster_Real(Session_All(NN), Channels(NN)) = Cluster_Real(Session_All(NN), Channels(NN)) + 1;

end 

plot_3D_activity_Amir(Cluster_Real, 0.05, 1, 'Cluster1_Location.mp4',{"Cluster1"});

%% Cluster 2

Cluster_Real = 0.001* ones(51,15);

for i = 1:length(Neurons_Number{2})
    
    NN = Neurons_Number{2}(i);
    Cluster_Real(Session_All(NN), Channels(NN)) = Cluster_Real(Session_All(NN), Channels(NN)) + 1;

end 

plot_3D_activity_Amir(Cluster_Real, 0.05, 1, 'Cluster2_Location.mp4',{"Cluster2"});

%% Cluster 3

Cluster_Real = 0.001* ones(51,15);

for i = 1:length(Neurons_Number{3})
    
    NN = Neurons_Number{3}(i);
    Cluster_Real(Session_All(NN), Channels(NN)) = Cluster_Real(Session_All(NN), Channels(NN)) + 1;

end 

plot_3D_activity_Amir(Cluster_Real, 0.05, 1, 'Cluster3_Location.mp4',{"Cluster3"});