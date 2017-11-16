%clear all
dbstop if error
%fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/';
Batch = 1;
filePath = [fileRoot,'Batch',num2str(Batch),'/'];
%fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
<<<<<<< HEAD
fileName = fullfile(filePath,'video_track_center_pose.mat');
=======
fileName = fullfile(filePath,'video_track_b1test.mat');
>>>>>>> a3f491cc0473add0d0fa2444229037956ca1a13e
load(fileName);
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
addpath('~/Documents/CPM/testing');
param = config();
%% Removing Outliers
clear  NewTracj
order = 2;
lambda = 1;
<<<<<<< HEAD

for Nvideo = 1 %: length(video_single)
    videoPrediction = video_singleOnly_Result(Nvideo).prediction;
   %videoPrediction = video_single(Nvideo).Results;
   np = size(videoPrediction{1,1},1);
   Joint_Frm = cell(1, np);
   frame = length(videoPrediction);
   dtTemp = cell2mat(videoPrediction);
=======
 CleanedTraj(1:length(video_track)) = struct('vidName',[],'traject',[]);
for Nvideo = 7 %: 5 %length(video_single)
   
    %videoPrediction = video_singleOnly_Result(Nvideo).prediction;
   Prediction = video_track(Nvideo).prediction;
   Rect = video_track(Nvideo).annorect;
    for nPerson = 1 : length(Rect)
        videoPrediction = Prediction(nPerson).pred;
        njt = size(videoPrediction{1,1},1); % number of joints
        Joint_Frm = cell(1, njt);
        frame = length(videoPrediction);
        dtTemp = cell2mat(videoPrediction);
>>>>>>> a3f491cc0473add0d0fa2444229037956ca1a13e
   
        for j = 1:njt
        Joint_Frm{j} = reshape(dtTemp(j, :), 2, []);
        end
         Trajec_new = cell(1, njt);
         Omega = cell(1, njt);
        for j = 1 : njt
            [omegaX, pX, cntX] = outlierDetectionSOS(Joint_Frm{1,j}(1,:), order+1);
            [omegaY, pY, cntY] = outlierDetectionSOS(Joint_Frm{1,j}(2,:), order+1);
            omega = double(omegaX & omegaY);
            Trajec_new{j} = l2_fastalm_mo(Joint_Frm{1,j},lambda,'omega',omega);
            Omega{j} = omega;
        end


        NewTraj = cell(1,frame);
        pose = zeros(njt,2);
        for i = 1 : frame
    
   
            for j = 1 : njt
                joint = Trajec_new{1,j}(:,i);
                pose(j,:) = joint';
       
        
            end
    
            NewTraj{1,i} = pose;
     
        end
        Traj(nPerson).trj = NewTraj;
    
    end
CleanedTraj(Nvideo).vidName = video_track(Nvideo).vidName;
CleanedTraj(Nvideo).traject = Traj;
end
%
%% Visualization
close all
%Picroot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/MPII_videos/Batch1_single/';
Picroot = '/Users/yuexizhang/Documents/Realtime/Video/';
PicPath = [Picroot,num2str(Batch),'/'];
<<<<<<< HEAD
close all
root = '/media/yuexi/DATA/MPII_data/1/';
%load('../VideoResults/Batch1/video_singleOnly_test.mat');
load('/home/yuexi/Documents/CPM/VideoResults/Batch1/video_track_center_pose.mat', 'video_track')
%load('/home/yuexi/Documents/CPM/VideoResults/Batch1/video_track_center.mat', 'video_track')
%imPath = '/Users/yuexizhang/Documents/Realtime/Video/1/000919705';
param = config();
c = hsv(20);

=======
% close all
>>>>>>> a3f491cc0473add0d0fa2444229037956ca1a13e
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
for Nvideo = 7 %: 5
imPath = [PicPath,CleanedTraj(Nvideo).vidName]; 
imlist = dir(fullfile(imPath,'*.jpg'));
% addpath(genpath('testing'));
% load('../VideoResults/test.mat');

 %videoPrediction = video_singleOnly_Result(Nvideo).prediction;
 %videoPrediction = NewTraj;
 Traject = CleanedTraj(Nvideo).traject;

    for i = 1 : length(imlist)
    
        %test_image = [imgPath,annolist_test_single(i).image.name];
        hold off
        test_image = [imlist(i).folder,'/',imlist(i).name];
        im = imread(test_image);
     
        imshow(im)
        title([num2str(i),'/',num2str(length(imlist))]);
        hold on;
        for nPerson = 1 %: length(prediction)
            videoPrediction = Traject(nPerson).trj;
            %videoPrediction = video_track(Nvideo).prediction(np).pred;
                %test_image = [imgPath,annolist_test_single(i).image.name];
            
            visualizeSkeleton(videoPrediction{1,i}, param);
            

                %MFV_test(i) = getframe(gcf);
%     
            %pause(0.05);
            pause;
       
        end
    end

%my_frame2video(MFV_test,1,'video1_orig');
end



