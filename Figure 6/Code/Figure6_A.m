%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% %%%%%%%%%%%%%%%%%%%  Figure 6 -A %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clc;clear;close all

paths = setupProject(pwd);  
addpath(paths.utils)

load(fullfile(paths.data,'Fig6A_Data.mat'))

%% Figure 6 - A 
figure()
tiledlayout(5,1,'TileSpacing','tight');
nexttile
plot(Actual_A,'Color','k','LineWidth',2)
xlim([1 length(Actual_A)])
title('Actual Narrow-Band Envelope','FontSize',14,'FontWeight','bold','FontName','Arial')
axis off

Clr = {'#C8554E','#0097A7','#512DA8'};
tt = {'Input Features + PCA','First BiLSTM + Droupout + PCA','Second BiLSTM + Droupout + PCA'};
clear Comp1 Comp2
L = 0;
for layer = [1,3,5]
    L = L+1;
    act = activations(Tnetwork,XTest{1},layer);
    activations_All{L} = act{1}; 
    
    coeff = pca(act{1}');
    Y = act{1}'*coeff(:,1);

    nexttile
    plot(Y,'Color',Clr{L},'LineWidth',2)
    R = corrcoef(Actual_A,Y);
    title({tt{L},[' r = ',num2str(R(1,2))]},'Color',Clr{L},'FontSize',14,'FontWeight','bold','FontName','Arial')
    axis off
    xlim([1 length(Y)])

end

nexttile
plot(double(Predict_A),'Color','k','LineWidth',2)
title('Predicted Envelope','FontSize',14,'FontWeight','bold','FontName','Arial')
xlim([1 length(Y)])
axis off