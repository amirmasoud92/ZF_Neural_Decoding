%% Figure 4 --- A & B --- 3 & 4 ---
%% Spatial Map of Decoding Performance 

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%      LFP        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakRate    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial Dist Perf 
clear;clc;close all; 
paths = setupProject(pwd);  
addpath(paths.utils)

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];

load(fullfile(paths.data,'Channel_List_Map.mat'))

SizeScale = importdata(fullfile(paths.data,'SizeCh_LFP_PeakRate.mat'));


%% MUAe Performance
LFP_EnvelopePerf = importdata(fullfile(paths.data,'LFP_Envelope_Landmarks_Detect_Results_Table_New.mat'));

%% Perf Sessions
for i = 1:51
    LFP_S_Perf(i) = mean(LFP_EnvelopePerf.Accuracy_PeakRate(find(LFP_EnvelopePerf.Session_Number==i)));
end 
%%
Depth_Uniq = depth_all;

Channel_Depth_Perf_MUAe = zeros(15,51);

for i = 1:51
        
    Channel_Depth_Perf_MUAe(:,i) = LFP_S_Perf(i)*ones(15,1);

end


Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];

hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',6)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)


for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',1)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',1)
    end
end

hold on; 

view(-35,30)
%% Select Important Channels
Selected  = 0.01*ones(51,15);

for i = 1:size(SizeScale,1)

    Size = SizeScale(i,:);
    %% 
    [~,I] =  sort(Size,'descend');
    S1 = I(1:4);

    %% 
    S2 = find(Size>10);
    
    %% 
    SS = unique([S1,S2]);
    Selected(i,SS) = Size(SS);

end 

%% 

for i = 1:size(Channel_Depth_Perf_MUAe,1)
    for j = 1:size(Channel_Depth_Perf_MUAe,2)
        if ~isnan(Channel_Depth_Perf_MUAe(i,j))

            SizeCh = Selected(j,i);

            scatter3(Loc_Channel_all(i,1),Loc_Channel_all(i,2),Depth_Uniq(j),...
                40*SizeCh,Channel_Depth_Perf_MUAe(i,j),'filled','MarkerEdgeColor','k');

            hold on

        end
    end
end

xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

clim([20 60])


xlabel('ML (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title('PeakRate Detection (LFP)','FontSize',28,'FontWeight','bold','FontName','Arial')


grid on
%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})

x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [1, 0, 0]; 

ax.GridAlpha = 0.7; 

grid on;

%% Save view 
videoFileName = 'LFP_PeakRate.mp4';
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

h = colorbar;
set(get(h,'label'),'string','Accuracy (%)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%      LFP        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakEnv     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial Dist Perf 
clear;clc;
paths = setupProject(pwd);  
addpath(paths.utils)

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];

load(fullfile(paths.data,'Channel_List_Map.mat'))

SizeScale = importdata(fullfile(paths.data,'SizeCh_LFP_PeakEnv.mat'));

%% MUAe Performance
LFP_EnvelopePerf = importdata(fullfile(paths.data,'LFP_Envelope_Landmarks_Detect_Results_Table_New.mat'));

%% Perf Sessions
for i = 1:51
    
    LFP_S_Perf(i) = mean(LFP_EnvelopePerf.Accuracy_PeakEnv(find(LFP_EnvelopePerf.Session_Number==i)));

end 
%%
Depth_Uniq = depth_all;

Channel_Depth_Perf_MUAe = zeros(15,51);

for i = 1:51
        Channel_Depth_Perf_MUAe(:,i) = LFP_S_Perf(i)*ones(15,1);
end

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];

hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',6)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)

for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',1)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',1)
    end
end

hold on; 

view(-35,30)
%% Select Important Channels
Selected  = 0.01*ones(51,15);

for i = 1:size(SizeScale,1)
    Size = SizeScale(i,:);
    %% 
    [~,I] =  sort(Size,'descend');
    S1 = I(1:4);

    %% 
    S2 = find(Size>10);
    
    %% 
    SS = unique([S1,S2]);
    Selected(i,SS) = Size(SS);
end 

%% 

for i = 1:size(Channel_Depth_Perf_MUAe,1)
    for j = 1:size(Channel_Depth_Perf_MUAe,2)
        if ~isnan(Channel_Depth_Perf_MUAe(i,j))

            SizeCh = Selected(j,i);

            scatter3(Loc_Channel_all(i,1),Loc_Channel_all(i,2),Depth_Uniq(j),40*SizeCh,Channel_Depth_Perf_MUAe(i,j),'filled','MarkerEdgeColor','k');
            
            hold on

        end
    end
end

xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

clim([20 60])

% Labels
xlabel('ML (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title('PeakEnv. Detection (LFP)','FontSize',28,'FontWeight','bold','FontName','Arial')


grid on

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})

x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [1, 0, 0]; 

ax.GridAlpha = 0.7; 
% Enable the grid
grid on;


%% Save view 

videoFileName = 'LFP_PeakEnv.mp4';
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

h = colorbar;
set(get(h,'label'),'string','Accuracy (%)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%      MUAe        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakRate     %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial Dist Perf 
clear;clc;
paths = setupProject(pwd);  
addpath(paths.utils)

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];

load(fullfile(paths.data,'Channel_List_Map.mat'));

SizeScale = importdata(fullfile(paths.data,'SizeCh_MUA_PeakRate.mat'));

%% MUAe Performance
MUAe_EnvelopePerf = importdata(fullfile(paths.data,'MUAe_Envelope_Landmarks_Detect_Results_Table_New.mat'));

%% Perf Sessions
for i = 1:51
    
    MUAe_S_Perf(i) = mean(MUAe_EnvelopePerf.Accuracy_PeakRate(find(MUAe_EnvelopePerf.Session_Number==i)));

end 
%%
Depth_Uniq = depth_all;

Channel_Depth_Perf_MUAe = zeros(15,51);

for i = 1:51
        Channel_Depth_Perf_MUAe(:,i) = MUAe_S_Perf(i)*ones(15,1);
end

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];

hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',6)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)

for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',1)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',1)
    end
end

hold on; 

view(-35,30)

%% Select Important Channels
Selected  = 0.01*ones(51,15);

for i = 1:size(SizeScale,1)
    Size = SizeScale(i,:);
    %% 
    [~,I] =  sort(Size,'descend');
    S1 = I(1:4);

    %% 
    S2 = find(Size>10);
    
    %% 
    SS = unique([S1,S2]);
    Selected(i,SS) = Size(SS);
end 

%% 

for i = 1:size(Channel_Depth_Perf_MUAe,1)
    for j = 1:size(Channel_Depth_Perf_MUAe,2)
        if ~isnan(Channel_Depth_Perf_MUAe(i,j))

            SizeCh = Selected(j,i);

            scatter3(Loc_Channel_all(i,1),Loc_Channel_all(i,2),Depth_Uniq(j),40*SizeCh,Channel_Depth_Perf_MUAe(i,j),'filled','MarkerEdgeColor','k');
            
            hold on

        end
    end
end


xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

clim([20 60])

% Labels
xlabel('ML (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title('PeakRate Detection (MUAe)','FontSize',28,'FontWeight','bold','FontName','Arial')

grid on

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})

x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [1, 0, 0]; 

ax.GridAlpha = 0.7; 

grid on;


%% Save view 

videoFileName = 'MUAe_PeakRate.mp4';
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

h = colorbar;
set(get(h,'label'),'string','Accuracy (%)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%      MUAe        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%     PeakEnv      %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Spatial Dist Perf 
clear;clc
paths = setupProject(pwd);  
addpath(paths.utils)

depth_all = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];

load(fullfile(paths.data,'Channel_List_Map.mat'));
SizeScale = importdata(fullfile(paths.data,'SizeCh_MUA_PeakEnv.mat'));

%% MUAe Performance

MUAe_EnvelopePerf = importdata(fullfile(paths.data,'MUAe_Envelope_Landmarks_Detect_Results_Table_New.mat'));

%% Perf Sessions
for i = 1:51

    MUAe_S_Perf(i) = mean(MUAe_EnvelopePerf.Accuracy_PeakEnv(find(MUAe_EnvelopePerf.Session_Number==i)));

end 
%%
Depth_Uniq = depth_all;

Channel_Depth_Perf_MUAe = zeros(15,51);

for i = 1:51
        Channel_Depth_Perf_MUAe(:,i) = MUAe_S_Perf(i)*ones(15,1);
end

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];

hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',6)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)


for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',1)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',1)
    end
end

hold on; 

view(-35,30)
%% Select Important Channels
Selected  = 0.01*ones(51,15);

for i = 1:size(SizeScale,1)
    Size = SizeScale(i,:);

    [~,I] =  sort(Size,'descend');
    S1 = I(1:4);

    S2 = find(Size>10);

    SS = unique([S1,S2]);
    Selected(i,SS) = Size(SS);

end 

%% 

for i = 1:size(Channel_Depth_Perf_MUAe,1)
    for j = 1:size(Channel_Depth_Perf_MUAe,2)
        if ~isnan(Channel_Depth_Perf_MUAe(i,j))

            SizeCh = Selected(j,i);

            scatter3(Loc_Channel_all(i,1),Loc_Channel_all(i,2),Depth_Uniq(j),40*SizeCh,Channel_Depth_Perf_MUAe(i,j),'filled','MarkerEdgeColor','k');
            
            hold on

        end
    end
end

xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap(othercolor('Paired6'))

clim([20 60])

% Labels
xlabel('ML (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title('PeakEnv. Detection (MUAe)','FontSize',28,'FontWeight','bold','FontName','Arial')

grid on

%%
xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})

x0=50;
y0=50;
width=800;
height=900;
set(hFig,'position',[x0,y0,width,height])
ax = gca;

ax.Color = [0 0 0];  

ax.GridColor = [1, 0, 0]; 

ax.GridAlpha = 0.7; 
% Enable the grid
grid on;


%% Save view 

videoFileName = 'MUAe_PeakEnv.mp4';
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

h = colorbar;
set(get(h,'label'),'string','Accuracy (%)','Rotation',270);
h.Label.Position(1) = 5;
h.FontSize = 20;
h.FontName = 'Arial';