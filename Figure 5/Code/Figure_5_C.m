%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       C1        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     Event       %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

%% 
load(fullfile(paths.data,'MI_Mean_SUA_EventDetection.mat'))
load(fullfile(paths.data,'SU_Info_All.mat'))
%%
PTHRE = mean(MI_F_SU) + std(MI_F_SU);
Selected_SU = find(MI_F_SU>PTHRE);

MI_Selected_SU = MI_F_SU(Selected_SU);
[MI_Selected_SU, IDX] = sort(MI_Selected_SU,'ascend');
Session_SU = NeuronsD.SessionNumber(Selected_SU); Session_SU = Session_SU(IDX);
Channel_SU = NeuronsD.RecordingChannel(Selected_SU); Channel_SU = Channel_SU(IDX); 

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];
Depth_Uniq = depth_all;

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];
%%
hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})
%%
hold on
scatter3(Loc_Channel_all(Channel_SU,1),Loc_Channel_all(Channel_SU,2),depth_all(Session_SU),...
    round(700*(MI_Selected_SU./mean(MI_Selected_SU))),MI_Selected_SU,'filled','MarkerFaceAlpha',.85,'MarkerEdgeColor','k','LineWidth',1)
%% 
%%
for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1), ...
            ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',0.5)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1), ...
            ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',0.5)
    end
end

hold on; 
view(-35,30)

%%
xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy
colormap(othercolor('Paired6'))

MCLIM = mean(MI_F_SU); SCLIM = std(MI_F_SU);
clim([MCLIM+0.5*SCLIM MCLIM+3.5*SCLIM])


% Labels
xlabel('ML (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title({''},'FontSize',40,'FontWeight','bold','FontName','Arial')

grid on

%%
x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [0.5, 0.5, 0.5]; 

ax.GridAlpha = 0.4; 
% Enable the grid
grid on;
colorbar
%%
%% Save view 
videoFileName = 'MI_EventDetection_SUA.mp4';
v = VideoWriter(videoFileName, 'MPEG-4');
v.FrameRate = 10; 
open(v);

ax = gca;

for angle = 80:-0.5:-80

    view(ax,angle, 30);
       
    frame = getframe(hFig);
    
    writeVideo(v, frame);

end


close(v);

disp(['Video saved as ' videoFileName]);

view(-35,30)
%%
h = colorbar;
set(get(h,'label'),'string','MI (bits)','Rotation',270);
h.Label.Position(1) = 5.5;
h.FontSize = 20;
h.FontName = 'Arial';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       C2        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     Envelope    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

%% 
load(fullfile(paths.data,'MI_Mean_SUA_EnvelopeDecoding.mat'))
load(fullfile(paths.data,'SU_Info_All.mat'))
%%
PTHRE = mean(MI_F_SU) + std(MI_F_SU);
Selected_SU = find(MI_F_SU>PTHRE);

MI_Selected_SU = MI_F_SU(Selected_SU);
[MI_Selected_SU, IDX] = sort(MI_Selected_SU,'ascend');
Session_SU = NeuronsD.SessionNumber(Selected_SU); Session_SU = Session_SU(IDX);
Channel_SU = NeuronsD.RecordingChannel(Selected_SU); Channel_SU = Channel_SU(IDX); 

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];
Depth_Uniq = depth_all;

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];
%%
hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})
%%
hold on
scatter3(Loc_Channel_all(Channel_SU,1),Loc_Channel_all(Channel_SU,2),depth_all(Session_SU),...
    round(500*(MI_Selected_SU./mean(MI_Selected_SU))),MI_Selected_SU,'filled','MarkerFaceAlpha',.9,'MarkerEdgeColor','k','LineWidth',1)
%% 
%%
for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#FCF3CF','LineWidth',0.5)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#D6DBDF','LineWidth',0.5)
    end
end

hold on; 
view(-35,30)

%%
xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

MCLIM = mean(MI_F_SU); SCLIM = std(MI_F_SU);
clim([MCLIM+1*SCLIM MCLIM+3*SCLIM])


% Labels
xlabel('ML (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title({''},'FontSize',40,'FontWeight','bold','FontName','Arial')
colorbar

%%
x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [0.5, 0.5, 0.5]; 

ax.GridAlpha = 0.4; 
% Enable the grid
grid on;

%%
%% Save view 

videoFileName = 'MI_EnvelopeDecode_SUA.mp4';
v = VideoWriter(videoFileName, 'MPEG-4');
v.FrameRate = 10; 
open(v);

ax = gca;

for angle = 80:-0.5:-80
    view(ax,angle, 30);
   
    frame = getframe(hFig);
    writeVideo(v, frame);
end

close(v);

disp(['Video saved as ' videoFileName]);

view(-35,30)
%%
h = colorbar;
set(get(h,'label'),'string','MI (bits)','Rotation',270);
h.Label.Position(1) = 5.5;
h.FontSize = 20;
h.FontName = 'Arial';


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       C3        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakRate    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

%% 
load(fullfile(paths.data,'Corr_SUA_Env_Landmarks.mat'))
load(fullfile(paths.data,'SU_Info_All.mat'))
MI_F_SU = Mean_PeakRate_SU; 
%%
PTHRE = mean(MI_F_SU) + std(MI_F_SU);
Selected_SU = find(MI_F_SU>PTHRE);

MI_Selected_SU = MI_F_SU(Selected_SU);
[MI_Selected_SU, IDX] = sort(MI_Selected_SU,'ascend');
Session_SU = NeuronsD.SessionNumber(Selected_SU); Session_SU = Session_SU(IDX);
Channel_SU = NeuronsD.RecordingChannel(Selected_SU); Channel_SU = Channel_SU(IDX); 

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];
Depth_Uniq = depth_all;

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];
%%
hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})
%%
hold on
scatter3(Loc_Channel_all(Channel_SU,1),Loc_Channel_all(Channel_SU,2),depth_all(Session_SU),...
    round(500*(MI_Selected_SU./mean(MI_Selected_SU))),MI_Selected_SU,'filled','MarkerFaceAlpha',.9,'MarkerEdgeColor','k','LineWidth',1)
%% 
%%
for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#FCF3CF','LineWidth',0.5)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#D6DBDF','LineWidth',0.5)
    end
end

hold on; 
view(-35,30)

%%
xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

MCLIM = mean(MI_F_SU); SCLIM = std(MI_F_SU);
clim([MCLIM+1*SCLIM MCLIM+3*SCLIM])


% Labels
xlabel('ML (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title({''},'FontSize',40,'FontWeight','bold','FontName','Arial')
colorbar

%%
x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [0.5, 0.5, 0.5]; 

ax.GridAlpha = 0.4; 
% Enable the grid
grid on;

%%
%% Save view 

videoFileName = 'Corr_PeakRate_SUA.mp4';
v = VideoWriter(videoFileName, 'MPEG-4');
v.FrameRate = 10; 
open(v);

ax = gca;

for angle = 80:-0.5:-80
    view(ax,angle, 30);
   
    frame = getframe(hFig);
    writeVideo(v, frame);
end

close(v);

disp(['Video saved as ' videoFileName]);

view(-35,30)
%%
h = colorbar;
set(get(h,'label'),'string','Cross Correlation (a.u)','Rotation',270);
h.Label.Position(1) = 5.5;
h.FontSize = 20;
h.FontName = 'Arial';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%   Figure 5      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%       C4        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakEnv    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clc;clear all;close all
paths = setupProject(pwd);  
addpath(paths.utils)

%% 
load(fullfile(paths.data,'Corr_SUA_Env_Landmarks.mat'))
load(fullfile(paths.data,'SU_Info_All.mat'))
MI_F_SU = Mean_PeakEnv_SU; 
%%
PTHRE = mean(MI_F_SU) + std(MI_F_SU);
Selected_SU = find(MI_F_SU>PTHRE);

MI_Selected_SU = MI_F_SU(Selected_SU);
[MI_Selected_SU, IDX] = sort(MI_Selected_SU,'ascend');
Session_SU = NeuronsD.SessionNumber(Selected_SU); Session_SU = Session_SU(IDX);
Channel_SU = NeuronsD.RecordingChannel(Selected_SU); Channel_SU = Channel_SU(IDX); 

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];
Depth_Uniq = depth_all;

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];
%%
hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',2)

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})
%%
hold on
scatter3(Loc_Channel_all(Channel_SU,1),Loc_Channel_all(Channel_SU,2),depth_all(Session_SU),...
    round(500*(MI_Selected_SU./mean(MI_Selected_SU))),MI_Selected_SU,'filled','MarkerFaceAlpha',.9,'MarkerEdgeColor','k','LineWidth',1)
%% 
%%
for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#FCF3CF','LineWidth',0.5)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2), ...
            Depth_Uniq,'-','Color','#D6DBDF','LineWidth',0.5)
    end
end

hold on; 
view(-35,30)

%%
xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

MCLIM = mean(MI_F_SU); SCLIM = std(MI_F_SU);
clim([MCLIM+1*SCLIM MCLIM+3*SCLIM])


% Labels
xlabel('ML (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',40,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title({''},'FontSize',40,'FontWeight','bold','FontName','Arial')
colorbar

%%
x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [0.5, 0.5, 0.5]; 

ax.GridAlpha = 0.4; 
% Enable the grid
grid on;

%%
%% Save view 

videoFileName = 'Corr_PeakEnv_SUA.mp4';
v = VideoWriter(videoFileName, 'MPEG-4');
v.FrameRate = 10; 
open(v);

ax = gca;

for angle = 80:-0.5:-80
    view(ax,angle, 30);
   
    frame = getframe(hFig);
    writeVideo(v, frame);
end

close(v);

disp(['Video saved as ' videoFileName]);

view(-35,30)
%%
h = colorbar;
set(get(h,'label'),'string','Cross Correlation (a.u)','Rotation',270);
h.Label.Position(1) = 5.5;
h.FontSize = 20;
h.FontName = 'Arial';
