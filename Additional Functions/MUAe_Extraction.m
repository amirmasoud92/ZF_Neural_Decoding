%% Extract MUAe from MU neural signals
clc;clear;close all 

Fs = 25000;

Address = '...'; %% Load Data 

[b1,a1] = butter(3,2*[500 9000]/Fs,'bandpass');
[b2,a2] = butter(3,2*200/Fs,'low');

clear MUAe_Sessions

for i = 1:length(BirdsName)
    %% Load Data In each Birds; 
    MU_Data_Bird = importdata([Address,'MUA_',BirdsName{i},'.mat']);
    clear MUAe_D
    for j = 1:length(MU_Data_Bird)
        
        Filtered_MU1 = filtfilt(b1,a1,MU_Data_Bird{j}');
        Filtered_MU1 = abs(Filtered_MU1);
        Filtered_MU2 = filtfilt(b2,a2,Filtered_MU1);
        Filtered_MU2 = Filtered_MU2(1:25:end,:);
        MUAe_D{j} = Filtered_MU2;

    end

    MUAe_Sessions{i} = MUAe_D;

end 


