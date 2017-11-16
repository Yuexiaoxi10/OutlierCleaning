%clear all
dbstop if error
%fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/';
Batch = 1;
filePath = [fileRoot,'Batch',num2str(Batch),'/'];
%fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
fileName = fullfile(filePath,'video_track_center_pose.mat');
load(fileName);
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
addpath('~/Documents/CPM/testing');
param = config();
%% Removing Outliers
clear  NewTracj
order = 2;
lambda = 1;

for Nvideo = 1 %: length(video_single)
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
close all
%Picroot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/MPII_videos/Batch1_single/';
Picroot = '/Users/yuexizhang/Documents/Realtime/Video/';
PicPath = [Picroot,num2str(Batch),'/'];
close all
root = '/media/yuexi/DATA/MPII_data/1/';
%load('../VideoResults/Batch1/video_singleOnly_test.mat');
load('/home/yuexi/Documents/CPM/VideoResults/Batch1/video_track_center_pose.mat', 'video_track')
%load('/home/yuexi/Documents/CPM/VideoResults/Batch1/video_track_center.mat', 'video_track')
%imPath = '/Users/yuexizhang/Documents/Realtime/Video/1/000919705';
param = config();
c = hsv(20);

%dbstop if error
for vid = 7 %1 : 30
%imPath = [root,video_singleMulti_Result(vid).vidName]; 
imPath = [root,video_track(vid).vidName];
imlist = dir(fullfile(imPath,'*.jpg'));
addpath(genpath('testing'));
%load('../VideoResults/test.mat');
predict = video_track(vid).prediction;

 %predict = video_singleMulti_Result(vid).prediction;
    for i = 1 : length(imlist)
        
        hold off 

        test_image = [imlist(i).folder,'/',imlist(i).name];
        imshow(imread(test_image))
        title([num2str(i),'/',num2str(length(imlist))]) 
        hold on

        for np = 1 : length(predict) %number of person
            videoPrediction = predict(np).pred;
            visualizeSkeleton(videoPrediction{1,i}, param);
            mn = min(videoPrediction{1,i});
            mx = max(videoPrediction{1,i});
            rect = [mn,mx-mn+1];
            rectangle('Position',rect, 'EdgeColor',c(mod(np,20)+1,:), 'LineWidth',3);
            %pause(0.3);
        end 
        pause(0.3);
    end 
%my_frame2video(MFV_test,1,'video');
end

%%

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



