%% Detect ouliters of one joint over total frame length

  clear all
 load('./InputData/videoPrediction_UYDP.mat');
 load('./InputData/label.mat');


thresh = 0.2; % threshold for APK
Nvid = 20; % number of videos
np =8;
  APK_det = zeros(Nvid,np);%APK value for output
  APK_in = zeros(Nvid, np);%APK value for input data
OutlierFram_totalVideo = struct;
Jbld_total = struct;
% Jbld_total_flip = struct;
% NewTrajectory = struct;


 order = 2; %Moment order
 dim = 1;
 thres = nchoosek(order+dim, order); % threshold for SOS
%%
% Nvideo = 7;

dt = 2;
windSize = 10;

fram = 100;

%for Nvideo = 1 : Nvid 
for Nvideo = 1 : 2
    tic;
 [Pose_UYDP, label1, gt,chunk] = getPoses(videoPrediction_UYDP, label, Nvideo,fram);
% %  Pose_UYDP = getPoses(videoPrediction_UYDP,label, Nvideo,fram);

  
Pose_UYDP_flip = flip(Pose_UYDP);

[Jbld, SOS_score, Outlier,Joint_Frm] = OutlierDet(np,fram,Pose_UYDP,order,dim,thres,dt,windSize);

 [Jbld_flip, SOS_score_flip, Outlier_flip,Joint_Frm_flip] = OutlierDet(np,fram,Pose_UYDP_flip,order,dim,thres,dt,windSize);

Jbld_total(Nvideo).Jbld = Jbld;
Jbld_total(Nvideo).Jbld_flip = Jbld_flip;
SOS_total(Nvideo).SOS = SOS_score;
SOS_total(Nvideo).SOS_flip = SOS_score_flip;
ithOutlier(Nvideo).outlier = Outlier;
ithOutlier(Nvideo).outlier_flip = Outlier_flip;

%% Outlier frames

OutlierFram = cell(1,np);
 OutlierFram_flip = cell(1,np);
OutlierFram_Total = cell(1,np);

Omega = cell(1,np);
Trajec_new_sr = cell(1,np);
lambda = 0.2; 
lam1 = 10;
lam2 = Inf;


 eta_max = 9.6;
 Joint_Frm1 = Joint_Frm;

for k = 1 : np
    
    ithOut = Outlier{1,k};%
     ithOut_flip = Outlier_flip{1,k};
    
    ithFram = ithOut*dt+windSize; % the frame when outlier occured 
     ithFram_flip = ithOut_flip*dt+windSize;
    
    OutlierFram{1,k} = ithFram;
     OutlierFram_flip{1,k} = ithFram_flip;
   
    
     ithFram_flip_real = 101 - ithFram_flip; %100---1 99---2 98---3...
    
     ithFram_Total = [ithFram ;ithFram_flip_real];
%       ithFram_Total = ithFram;
    
     OutlierFram_Total{1,k} = ithFram_Total;
     

% smooth tracjectory
        omega = ones(1,fram);
        omega(:,ithFram) = 0; % set omega equals to 0 at the frame of outlier
         omega(:,ithFram_flip_real) = 0;%flip back to the original order
        
        up = zeros(2,fram);
        Omega{1,k} = omega;
        
         Joint_Frm{1,k}(:,ithFram) = 0;
          Joint_Frm{1,k}(:, ithFram_flip_real) = 0;
          
          % Using ALM:   
%            Trajec_new{1,k} = l2_fastalm_mo(Joint_Frm{1,k},lambda,'omega',Omega{1,k}); 

          % Using IHSTLN
          Trajec_new{1,k} = fast_incremental_hstln_mo(Joint_Frm{1,k},eta_max,'omega',Omega{1,k});
         
          % Using SRPCA    
%             mask = ones(prod(size(Joint_Frm1{1,k})),1);
%             Trajec_new_sr{1,k} = SRPCA_e1_e2_clean_md(Joint_Frm1{1,k}',lam1,lam2,mask');

        
    10;
    
end

  OutlierFram_totalVideo(Nvideo).Videos = OutlierFram_Total;
  

   NewTrajectory_sr(Nvideo).Trajec = Trajec_new;
%   Squence(Nvideo).vid = Joint_Frm1;%Input Sequence
  % Trajec_new = NewTrajectory(Nvideo).Trajec;

%% Getting APK evluation matrix

[gt_pose, Detection, inputDet] = preProcessAPK(label1, Trajec_new, Pose_UYDP);

apk_det = eval_apk(Detection, gt_pose, thresh);

apk_in= eval_apk(inputDet, gt_pose, thresh);

APK_det(Nvideo,:) = apk_det;
APK_in(Nvideo,:) = apk_in;


toc;
end
%  
%  
  %% Computing mean of APK for key points
[mean_h_det, mean_al_det, mean_sh_det] = APKmean(APK_det);
[mean_h_in, mean_al_in, mean_sh_in] = APKmean(APK_in);
MeanCompare = [mean_h_det mean_h_in; mean_al_det mean_al_in; mean_sh_det mean_sh_in];


 

