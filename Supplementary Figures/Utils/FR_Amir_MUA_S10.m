function Firing_rate = FR_Amir_MUA_S10(spike_time, window_size, overlap, time_window, nomral,smoothOpt,N_Trials)

Start_w = time_window(1);
window_t = 0;
L = 1;

if overlap>window_size
    fprintf('Overlap should be less that window size')
end

while time_window(end)>window_t(end)-window_size

    window_t = [Start_w,Start_w+window_size];
    Number_of_SpikeWindow = length(find(spike_time>window_t(1) & spike_time<window_t(2)));

    Firing_rate(L,:) = [mean(window_t) Number_of_SpikeWindow];

    Start_w = Start_w+overlap;
    L = L+1;

end



%% Normal Based on Baseline
if nomral==1
    %     N_FR = Firing_rata(:,2)./max(Firing_rata(:,2));
    A = find(Firing_rate(:,1)< 1);
    F0 = nanmean(Firing_rate(A,2));

    if F0~=0
        N_FR = (Firing_rate(:,2)-F0)/F0;
    else
        N_FR =  Firing_rate(:,2);
    end

%     order = 2; framelen = 49;
%     N_FR = sgolayfilt(N_FR,order,framelen);
%     N_FR = N_FR./max(N_FR);

    %     N_FR = zscore(N_FR);
    Firing_rate(:,2) = N_FR;

end

%% Z-score normalize 
if nomral==2

    Firing_rate(:,2) = zscore(Firing_rate(:,2));

end

%% 
if nomral==0
    if N_Trials~=0
    Firing_rate(:,2) = Firing_rate(:,2)./(window_size*N_Trials);
    end
end

%% 
if nomral==3
    if N_Trials~=0
        FR_E = Firing_rate(:,2);
        Firing_rate(:,2) = (FR_E - min(FR_E))./(max(FR_E) - min(FR_E));
    end
end
%%
if smoothOpt ==1
    order = 3; framelen = 9;
    Firing_rate(:,2) = sgolayfilt(Firing_rate(:,2),order,framelen);

end

end