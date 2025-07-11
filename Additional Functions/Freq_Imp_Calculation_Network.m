clc;close all;clear

Address = ...

LoadAddress = ...

IDX_Alll = importdata(['...']); %% Validation Index 
load('Channel_List_Map.mat')

LFP_Features_All = importdata([LoadAddress,'LFP_EnvelopeDecoding_AllFeatures.mat']);
STIM_DD_All = importdata([LoadAddress,'Stim_LFP_EnvelopeDecoding_C1.mat']);




for Session = 1:51
    clear Feature_Freq_All
    LFP_Features = LFP_Features_All{Session};
    STIM_DD = STIM_DD_All{Session};
    %%
    NN = rem(1:size(LFP_Features{1},1),8);
    Feature_Freq_All{1} = find(NN==1);
    Feature_Freq_All{2} = find(NN==2);
    Feature_Freq_All{3} = find(NN==3);
    Feature_Freq_All{4} = find(NN==4 | NN==5);
    Feature_Freq_All{5} = find(NN==6);
    Feature_Freq_All{6} = find(NN==7);

    %%
    sequenceLengths = arrayfun(@(x) size(x{1}, 2), LFP_Features);
    PLSongs = unique(sequenceLengths);

    NTrials  = length(LFP_Features);
    IDX_Eval = IDX_Alll{Session};
    Net_Session = importdata([Address,'Net_Results_Session',num2str(Session),'.mat']);
    Imp_All_Feature = [];

    for fold = 1:10
        tic
        %% Test Trials
        XTest = LFP_Features(IDX_Eval==fold);
        YTest = STIM_DD(IDX_Eval==fold);

        net  = Net_Session{fold};

        clear R2_Perm R2_BaseLine ImportFeature

        for Freq = 1:6
            F_Ch = Feature_Freq_All{Freq};

            for TTest = 1:length(XTest)

                Test_Features = XTest{TTest};
                Test_Features_Perm  = Test_Features;

                YPred = predict(net,Test_Features);

                mdl = fitlm(YPred,YTest{TTest}); 
                R2_BaseLine(TTest) = mdl.Rsquared.Adjusted; 


                for P = 1:length(F_Ch)
                    Sh = randperm(size(Test_Features,2));
                    Test_Features_Perm(F_Ch(P),Sh) = randomPhaseShuffle(Test_Features(F_Ch(P),:)) ;
                end

                YPred = predict(net,Test_Features_Perm);
                mdl = fitlm(YPred,YTest{TTest}); 
                R2_Perm(TTest,Freq) = mdl.Rsquared.Adjusted;                 
                
                ImportFeature(TTest,Freq) = R2_Perm(TTest,Freq) - R2_BaseLine(TTest);

            end
        end

        Imp_All_Feature = [Imp_All_Feature;double(ImportFeature)];
        clear ImportFeature

    end

    Importance_Channel_Sessions{Session} = Imp_All_Feature;
    clear Imp_All_Feature
end

