dbstop if error
%fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
%fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/';
fileRoot = '/home/yuexi/Documents/CPM/VideoResults/';
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

CleanedTraj(1:length(video_track)) = struct('vidName',[],'traject',[]);
for Nvideo = 1 %: 5 %length(video_single)
   
    %videoPrediction = video_singleOnly_Result(Nvideo).prediction;
   Prediction = video_track(Nvideo).prediction;
   Rect = video_track(Nvideo).annorect;
    for nPerson = 1 : length(Rect)
        videoPrediction = Prediction(nPerson).pred;
        njt = size(videoPrediction{1,1},1); % number of joints
        Joint_Frm = cell(1, njt);
        frame = length(videoPrediction);
        dtTemp = cell2mat(videoPrediction);
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
%%
close all
%Picroot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/MPII_videos/Batch1_single/';
%Picroot = '/Users/yuexizhang/Documents/Realtime/Video/';
Picroot = '/media/yuexi/DATA/MPII_data/';
PicPath = [Picroot,num2str(Batch),'/'];
c = hsv(20);

for Nvideo = 1 %: 5
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
        for nPerson = 1 : length(Traject)
            videoPrediction = Traject(nPerson).trj;
            %videoPrediction = video_track(Nvideo).prediction(np).pred;
                %test_image = [imgPath,annolist_test_single(i).image.name];
            
            visualizeSkeleton(videoPrediction{1,i}, param);
            

                %MFV_test(i) = getframe(gcf);
   
        end
        pause(0.3);
    end

%my_frame2video(MFV_test,1,'video1_orig');
end






















