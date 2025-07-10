%% ITPC of LFP Frequency Bands
clc;clear;close all 

paths = setupProject(pwd);
addpath(paths.utils)

load(fullfile(paths.data,'S9','ITPCZ_MeanAmp_Sessions.mat'));
load(fullfile(paths.data,'S9','ITPCZ_FreqPlot.mat'));

FreqBands = [1 4;4 8;8 13;13 30;30 100];
ITPCzMeanFreq = [];

for i = 1:51
    L = 0;
    for j = 1:10
        ITPCZ_D = ITPCZ_Session{i}{j};
        for k = 1:size(FreqBands,1)
            L = L+1;
            if ~isempty(ITPCZ_D)

                A = find(FreqAll>FreqBands(k,1) & FreqAll<=FreqBands(k,2));
                ITPCzMeanFreq(L,i,:) = mean(ITPCZ_D(A,501:3500),1);

            end
        end
    end
end

%% 