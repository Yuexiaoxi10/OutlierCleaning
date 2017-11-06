%clear all
%fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/';
Batch = 1;
filePath = [fileRoot,'Batch',num2str(Batch),'/'];
%fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
fileName = fullfile(filePath,'video_singleOnly_Result.mat');
load(fileName);
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
addpath('~/Documents/CPM/testing');
param = config();
%% Removing Outliers
clear  NewTracj
order = 2;
lambda = 1;

for Nvideo = 15 %: length(video_single)
    videoPrediction = video_singleOnly_Result(Nvideo).prediction;
   %videoPrediction = video_single(Nvideo).Results;
   np = size(videoPrediction{1,1},1);
   Joint_Frm = cell(1, np);
   frame = length(videoPrediction);
   dtTemp = cell2mat(videoPrediction);
   
   for j = 1:np
        Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);

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
    
%    CleanedTraj(Nvideo).Traject = Trajec_new;
    


NewTracj = cell(1,frame);
pose = zeros(np,2);
for i = 1 : frame
    
   
    for j = 1 : np
        joint = Trajec_new{1,j}(:,i);
        pose(j,:) = joint';
       
        
    end
    
    NewTracj{1,i} = pose;
     
end

    CleanedTraj(Nvideo).Traject = NewTracj;
    
end
%
%% Visualization
%Picroot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/MPII_videos/Batch1_single/';
Picroot = '/Users/yuexizhang/Documents/Realtime/Video/';
PicPath = [Picroot,num2str(Batch),'/'];
close all
%dbstop if error
% for vid = 1 : 10
imPath = [PicPath,video_singleOnly_Result(Nvideo).vidName]; 
imlist = dir(fullfile(imPath,'*.jpg'));
% addpath(genpath('testing'));
% load('../VideoResults/test.mat');

 %videoPrediction = video_singleOnly_Result(Nvideo).prediction;
 videoPrediction = NewTracj;
 
for i = 1 : length(videoPrediction)
    
%test_image = [imgPath,annolist_test_single(i).image.name];
test_image = [imlist(i).folder,'/',imlist(i).name];
visualizeSkeleton(test_image, videoPrediction{1,i}, param);
title([num2str(i),'/', num2str(frame)]);

%MFV_test(i) = getframe(gcf);
%      
pause(0.1);
%pause;

end
%my_frame2video(MFV_test,1,'video1_orig');
% end



