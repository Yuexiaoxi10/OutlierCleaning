%% Detect ouliters of one joint over total frame length

clear;
[cwd] = fileparts(mfilename('fullpath'));
cd(cwd);
addpath(genpath('.'));
addpath(genpath('../3rdParty'));
load('./videoPrediction_UYDP.mat');
load('./label.mat');


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
dt = 2;
windSize = 10;
lambda = 0.2;
fram = 100;

%% Step 1 : preprocssing data and getting JBLD values
for Nvideo = 1 : Nvid
    %     for Nvideo = 12
    
    tic;
    [Pose_UYDP, label1, gt, chunk] = getPoses(videoPrediction_UYDP, label, Nvideo,fram);
    
    Joint_Frm = cell(1, np);
    Gt_Frm = cell(1, np);
    dtTemp = cell2mat(Pose_UYDP);
    gtTemp = cell2mat(gt);
    for j = 1:np
        Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);
        Gt_Frm{j} = reshape(gtTemp(j, :), 2, []);
    end
    
    Trajec_new = cell(1, np);
    Omega = cell(1, np);
    for j = 1 : np
        [omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,j}(1,:), order+1);
        [omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,j}(2,:), order+1);
        omega = double(omegaX & omegaY);
        Trajec_new{j} = l2_fastalm_mo(Joint_Frm{1,j},lambda,'omega',omega);
        Omega{j} = omega;
    end
    
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

fprintf('\t\tCleaned\t Original\n');
fprintf('Head\t\t%.2f\t%.2f\n',100*mean_h_det, 100*mean_h_in);
fprintf('Elbows\t\t%.2f\t%.2f\n',100*mean_al_det, 100*mean_al_in);
fprintf('Shoulders\t%.2f\t%.2f\n',100*mean_sh_det, 100*mean_sh_in);

