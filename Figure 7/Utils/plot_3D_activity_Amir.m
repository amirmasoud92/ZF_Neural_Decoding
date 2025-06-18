function [] = plot_3D_activity_Amir(Value_Plot, Thre_Value, Save3Dvideo, videoFileName,TitleInput)
%% Value Plot: (Brain Sites * Channels )

Depth_Uniq = 250*[0.5,1.4,1.5,1.6,1.9,2,2.5,2.8,2.9,3,3.4,3.9,4,4.3,4.4,4.5,...
    4.8,4.9,5,5.3,5.4,5.5,5.9,6,6.8,6.9,7,7.1,...
    7.2,7.3,7.4,7.5,7.6,7.7,7.9,8,8.1,8.2,8.5,8.6,...
    9,9.1,9.5,10,10.5,...
    3.1,3.5,4.6,5.1,6.1,6.5];

Loc_Channel_all = [1 8;1 7;0 7;1 6;0 6;0 5;1,4;0 4;1 3;0 3;1 2;1 1;0 1;1 0;0 0];

%%

hFig = figure();
hold on
plot3(1.2*ones(100,1),linspace(0,5,100),0*ones(100,1),'-','Color','#CD5C5C','LineWidth',6)
hold on
plot3(linspace(1.2,1,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)
hold on
plot3(linspace(1.2,1.4,100),linspace(0,-1,100),linspace(0,200,100),'-','Color','#CD5C5C','LineWidth',10)

hold on;

view(-35,30)

%% Select Channels and Depth

Selected  = ones(51,15)*10^-8;

for i = 1:size(Value_Plot,1)
    A = find(Value_Plot(i,:)>=Thre_Value);
    if ~isempty(A)
        Selected(i,A) = Value_Plot(i,A);
    end

end

for i = 1:size(Selected,1)

    for j = 1:size(Selected,2)

        if ~isnan(Selected(i,j))

            SizeCh = 1200*(Selected(i,j)./max(max(Selected)));

            scatter3(Loc_Channel_all(j,1),Loc_Channel_all(j,2),Depth_Uniq(i),SizeCh,Selected(i,j),'filled','MarkerEdgeColor','k','MarkerFaceAlpha',0.85,'LineWidth',1);

            hold on

        end
    end
end


hold on

for i = 1:size(Loc_Channel_all,1)
    hold on
    if ismember(i,[1,2,4,7,9,11,12,14])
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#FCF3CF','LineWidth',1.2)
    else
        plot3(ones(length(Depth_Uniq),1)*Loc_Channel_all(i,1),ones(length(Depth_Uniq),1)*Loc_Channel_all(i,2),Depth_Uniq,'-','Color','#D6DBDF','LineWidth',1.2)
    end
end

xlim([-0.5 1.5])
ylim([min(Loc_Channel_all(:,2))-2 max(Loc_Channel_all(:,2))+2])
set (gca,'Zdir','reverse')
axis xy

colormap copper

MCLIM = mean(max(Selected')); SCLIM = std(max(Selected'));
clim([MCLIM MCLIM+2*SCLIM])

% Labels
xlabel('ML (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
ylabel('CR (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
zlabel('DV (mm)','FontSize',28,'FontWeight','bold','FontName','Arial')
set(gca,'FontSize',20);

title(TitleInput,'FontSize',28,'FontWeight','bold','FontName','Arial')


grid on

xticks([0 1])
xticklabels({'1','0.5'})
yticks([0 2 4 6 8])
yticklabels({'0','0.5','1','1.5','2'})
zticks([0 500 1000 1500 2000 2500 3000])
zticklabels({'0','0.5','1','1.5','2','2.5','3'})


%% 3D Video Save
%%
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

%%
%% Save view

if Save3Dvideo ==1
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
end

end