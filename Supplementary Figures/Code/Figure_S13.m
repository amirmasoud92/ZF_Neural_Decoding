%% Figure S13 - t-SNE visualizations of latent space representations at various stages of 
%% time-locked feature detection (event and envelope landmarks) using LFP features.

%% Song Event Detection 
clc;clear;close all 

paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'S13','LFP Song Event','LFP_Features_All_Session15.mat'));
load(fullfile(paths.data,'S13','LFP Song Event','Network_All_Session15.mat'));
load(fullfile(paths.data,'S13','LFP Song Event','Actual_Event_Session15.mat'));

%% Test Trials
fold = 23;
C = [0.1 0 0.5;0.8 0 0.3];

Feature_T = LFP_Features{fold};
Network_T = Network_All{fold};

Layers_Name = {'Input Features + t-SNE',' First BiLSTM Layer + Droupout + t-SNE','Second BiLSTM Layer + Droupout + t-SNE'};

NLayer = [1,3,5];

figure()
tiledlayout(2,3,'TileSpacing','loose')
clear Comp1 Comp2
L = 0;

for layer = 1:length(NLayer)
    L = L+1;

    nexttile
    act = activations(Network_T,Feature_T,NLayer(layer));
    Activation_All{L} = act{1};
    
    Y = tsne(act{1}','Exaggeration',2,'Perplexity',40);
    
    gscatter(Y(:,1),Y(:,2),Stim_Act{fold},C,".",30)
    set(gca,'XTick',[], 'YTick', [])
    xlabel('Y1_{t-sne}','FontName','Arial','FontWeight','normal','FontSize',12);
    ylabel('Y2_{t-sne}','FontName','Arial','FontWeight','normal','FontSize',12);
    legend off
    
    title(Layers_Name{layer},'FontName','Arial','FontWeight','bold','FontSize',14)

    box off;
end


%% Envelope Features Detection 
clc;clear

paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'S13','LFP Song Event','LFP_Features_All_Session15.mat'));
load(fullfile(paths.data,'S13','LFP Song Event','Network_All_Session15.mat'));
load(fullfile(paths.data,'S13','LFP Song Event','Actual_Event_Session15.mat'));



load('C:\Amir\Phd research\code\Motion Artifact\Result Regression\Event\Result Env Label Song 50 New\LFP_Features_Session15.mat')
load('C:\Amir\Phd research\code\Motion Artifact\Result Regression\Event\Result Env Label Song 50 New\Network_All_Session15.mat')
load('C:\Amir\Phd research\code\Motion Artifact\Result Regression\Event\Result Env Label Song 50 New\Actual_Event_Session15.mat')

%% Test Trials
fold = 15;
C = [0.1 0 0.5;0.8 0 0.3;0.9290 0.6940 0.1250];
Feature_T = LFP_Features{fold};
Network_T = Network_All{fold};
Layers_Name = {'Input Features + t-SNE',' First BiLSTM Layer + Droupout + t-SNE','Second BiLSTM Layer + Droupout + t-SNE'};
NLayer = [1,3,5];

clear Comp1 Comp2

for layer = 1:length(NLayer)
    nexttile
    act = activations(Network_T,Feature_T,NLayer(layer));
    Y = tsne(act{1}','Exaggeration',3,'Perplexity',10);
    gscatter(Y(:,1),Y(:,2),Stim_Act{fold},C,".",30)
    set(gca,'XTick',[], 'YTick', [])
    xlabel('Y1_{t-sne}','FontName','Arial','FontWeight','normal','FontSize',12);
    ylabel('Y2_{t-sne}','FontName','Arial','FontWeight','normal','FontSize',12);
    legend off
    title(Layers_Name{layer},'FontName','Arial','FontWeight','bold','FontSize',14)
    box off;

end



