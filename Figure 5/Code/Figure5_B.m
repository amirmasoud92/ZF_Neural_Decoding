%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       B1        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     Event       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Fig5_A_Event_Bubbles.mat'))

%% plot Pannel A
fig = figure(); 
x0=50;
y0=50;
width=700;
height=600;
fig.Position = [x0,y0,width, height];
%%
bubblechart(Event_Bubbles.Mean_S_SU, Event_Bubbles.Mean_Accuracy,...
    Event_Bubbles.N_SU_S,Event_Bubbles.DepthS./1000); 
box off
%%
set(gca,'FontSize',20);
set(gca,'LineWidth',2)

xlabel('Information Rate (bits)','FontSize',24,'FontWeight','bold','FontName','Arial')
ylabel('Accuracy (%)','FontSize',24,'FontWeight','bold','FontName','Arial')
colormap(othercolor('Paired6'))

%%
h = colorbar;
set(get(h,'label'),'string','Depth (mm)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';
title({'Event Detection'},'FontSize',28,'FontWeight','bold','FontName','Arial')
grid off
ylim([50 100])
xlim([0 0.2])
blgd= bubblelegend('Num. Neurons','Style','horizontal','NumBubbles',3);
blgd.Location = 'southeast';

%% Linear Line Fit 
p = polyfit(Event_Bubbles.Mean_S_SU,Event_Bubbles.Mean_Accuracy,1); 
f = polyval(p,Event_Bubbles.Mean_S_SU); 
hold on; 
plot(Event_Bubbles.Mean_S_SU,f,'k--')

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       B2        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     Envelope    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Fig5_A_Envelope_Bubbles.mat'))

fig = figure(); 
x0=50;
y0=50;
width=700;
height=600;
fig.Position = [x0,y0,width, height];
%%
bubblechart(Envelope_Bubbles.Mean_S_SU, Envelope_Bubbles.Mean_Accuracy,...
    Envelope_Bubbles.N_SU_S,Envelope_Bubbles.DepthS./1000); 

box off
%%
set(gca,'FontSize',20);
set(gca,'LineWidth',2)

xlabel('Information Rate (bits)','FontSize',24,'FontWeight','bold','FontName','Arial')
ylabel('R-squared','FontSize',24,'FontWeight','bold','FontName','Arial')
colormap(othercolor('Paired6'))

%%
h = colorbar;
set(get(h,'label'),'string','Depth (mm)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';
title({'Envelope Decoding'},'FontSize',28,'FontWeight','bold','FontName','Arial')
grid off
ylim([0 0.9])
xlim([0 0.11])
blgd= bubblelegend('Num. Neurons','Style','horizontal','NumBubbles',3);
blgd.Location = 'southeast';

%% Linear Line Fit 
p = polyfit(Envelope_Bubbles.Mean_S_SU,Envelope_Bubbles.Mean_Accuracy,1); 
f = polyval(p,Envelope_Bubbles.Mean_S_SU); 
hold on; 
plot(Envelope_Bubbles.Mean_S_SU,f,'k--')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       B3        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakRate    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%  PeakRate 

clc;clear ;close all
paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Fig5_A_PeakRate_Bubbles.mat'))

%% plot Pannel A
fig = figure(); 
x0=50;
y0=50;
width=700;
height=600;
fig.Position = [x0,y0,width, height];
%%
bubblechart(PeakRate_Bubbles.Mean_S_SU,PeakRate_Bubbles.Mean_Accuracy,...
    PeakRate_Bubbles.N_SU_S,PeakRate_Bubbles.DepthS/1000) ;
box off

%%
set(gca,'FontSize',20);
set(gca,'LineWidth',2)

xlabel('Cross-Correlation','FontSize',24,'FontWeight','bold','FontName','Arial')
ylabel('Accuracy (%)','FontSize',24,'FontWeight','bold','FontName','Arial')
colormap(othercolor('Paired6'))

%%
h = colorbar;
set(get(h,'label'),'string','Depth (mm)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';
title({'PeakRate Detection'},'FontSize',28,'FontWeight','bold','FontName','Arial')
grid off
ylim([0 70])
xlim([0.05 0.23])
blgd= bubblelegend('Num. Neurons','Style','horizontal','NumBubbles',3);
blgd.Location = 'southeast';

%% Linear Line Fit 
p = polyfit(PeakRate_Bubbles.Mean_S_SU,PeakRate_Bubbles.Mean_Accuracy,1); 
f = polyval(p,PeakRate_Bubbles.Mean_S_SU); 
hold on; 
plot(PeakRate_Bubbles.Mean_S_SU,f,'k--')


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       B3        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakEnv     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear ;close all
paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Fig5_A_PeakEnv_Bubbles.mat'))


%% plot Pannel A
fig = figure(); 
x0=50;
y0=50;
width=700;
height=600;
fig.Position = [x0,y0,width, height];
%%
bubblechart(PeakEnv_Bubbles.Mean_S_SU,PeakEnv_Bubbles.Mean_Accuracy,...
    PeakEnv_Bubbles.N_SU_S,PeakEnv_Bubbles.DepthS/1000) ;
box off

%%
set(gca,'FontSize',20);
set(gca,'LineWidth',2)

xlabel('Cross-Correlation','FontSize',24,'FontWeight','bold','FontName','Arial')
ylabel('Accuracy (%)','FontSize',24,'FontWeight','bold','FontName','Arial')
colormap(othercolor('Paired6'))

%%
h = colorbar;
set(get(h,'label'),'string','Depth (mm)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';
title({'PeakEnv. Detection'},'FontSize',28,'FontWeight','bold','FontName','Arial')
grid off
ylim([0 75])
xlim([0.07 0.23])
blgd= bubblelegend('Num. Neurons','Style','horizontal','NumBubbles',3);
blgd.Location = 'southeast';

%% Linear Line Fit 
p = polyfit(PeakEnv_Bubbles.Mean_S_SU,PeakEnv_Bubbles.Mean_Accuracy,1); 
f = polyval(p,PeakEnv_Bubbles.Mean_S_SU); 
hold on; 
plot(PeakEnv_Bubbles.Mean_S_SU,f,'k--')

