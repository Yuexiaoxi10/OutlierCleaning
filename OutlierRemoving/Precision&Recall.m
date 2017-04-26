clear;clc;
load('videoPrediction_UYDP.mat');
load('label');
%%
np = 8;
fram = 100; % number of frames for each video
Nvid = 20; % Total video numbers
T = 5;
threshvalue = 1 : 0.1 : T;
Precision = zeros(1,length(threshvalue));
Recall = zeros(1,length(threshvalue));
 order = 2; %Moment order
 dim = 1;
 
%% Get outliers

for N = 1 : length(threshvalue)
   
    thres = threshvalue(:,N);
    
    Test_1by1;


Threshold = 20; % threshold for dection positions
OutlierCompare_total = struct;

for Nvideo = 1 : Nvid
    
    [Pose_UYDP, label1] = getPoses(videoPrediction_UYDP, label, Nvideo, fram);
    
    OutlierCompare = OutlierCheck(label1, Pose_UYDP, OutlierFram_totalVideo(Nvideo).Videos, fram, np, Threshold);
    
    
    OutlierCompare_total(Nvideo).VideoOut = OutlierCompare; % overal evaluations over all videos
     
end


%% Summing all TP,FP,FN

Sum_TP_total = 0; Sum_FN_total = 0; Sum_FP_total = 0;

for Nvideo = 1 : Nvid
    Sum_TP = 0; Sum_FP = 0; Sum_FN = 0;
    OutlierCompare1 = OutlierCompare_total(Nvideo).VideoOut;
    
    
    for k = 1 : np
        Sum_TP = Sum_TP + length(OutlierCompare1(k).TruePosi);
        Sum_FN = Sum_FN + length(OutlierCompare1(k).FalseNeg);
        Sum_FP = Sum_FP + length(OutlierCompare1(k).FalsePosi_FA);
         
    end
    
     Sum_TP_total = Sum_TP_total + Sum_TP;
     Sum_FN_total = Sum_FN_total + Sum_FN;
     Sum_FP_total = Sum_FP_total + Sum_FP;
    
end

Precision(1,N) = Sum_TP_total/(Sum_TP_total + Sum_FP_total);
Recall(1,N) = Sum_TP_total/(Sum_TP_total + Sum_FN_total);
end


%%
figure(1)
plot(Recall(1,:),Precision(1,:),'r-*');
title('PR Curve');
xlabel('Recall');
ylabel('Precision');






