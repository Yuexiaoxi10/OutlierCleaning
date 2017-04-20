%%
% load('label.mat'); load('videoPrediction_UYDP.mat');
%%
dt = 2; fr = 10;
np = 8; fram = 100;
order = 2; %Moment order
dim = 1;
Nvid = 20;
thres = nchoosek(order+dim, order);

thresh = 0.2; % threshold for APK

APK_det = zeros(Nvid,np);
APK_in = zeros(Nvid, np);
% OutlierFram_Jbld = struct;
lambda = 10;
NewTracj_Jbld = struct;
ThreshValues = {0.26, 0.2, 0.225, 0.38, 0.385, 0.225, 0.38, 0.385};

for Nvideo = 1 : Nvid
    
    [Pose_UYDP, label1] = getPoses(videoPrediction_UYDP, label, Nvideo,fram);
    
    [Jbld, SOS_score,Outlier, Joint_Frm] = OutlierDet(np,fram,Pose_UYDP,order,dim,thres);
  
    %%
    Outlier_Jbld = cell(1,np);
    NewTraj = cell(1,np);
    Omega = cell(1,np);
    
    for kk = 1 : np
        
        JbldVal = Jbld{1,kk}; 
        ThreshVal = ThreshValues{1,kk};
        ithOut = find(JbldVal > ThreshVal);
        Outlier_Jbld{1,kk} = ithOut;
        ithFram = ithOut*dt+fr;
        % smooth tracj
         omega = ones(1,fram);
         omega(:,ithFram) = 0;
%          up = zeros(2,fram);
         Omega{1,kk} = omega;
         
         Joint_Frm{1,kk}(:,ithFram) = 0;
         NewTraj{1,kk} = l2_fastalm_mo(Joint_Frm{1,kk},lambda,'omega',Omega{1,kk});
        
           
    end
        
       NewTracj_Jbld(Nvideo).Outliers = Outlier_Jbld; 
       NewTracj_Jbld(Nvideo).Trajectory = NewTraj;
       
       [gt_pose, Detection, inputDet] = preProcessAPK(label1, NewTraj, Pose_UYDP);

        apk_det = eval_apk(Detection, gt_pose, thresh);

        apk_in= eval_apk(inputDet, gt_pose, thresh);

        APK_det(Nvideo,:) = apk_det;
        APK_in(Nvideo,:) = apk_in;
       
       
       
            
end
    
  
    

