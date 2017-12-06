dbstop if error
%fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/'; % ios
%fileRoot = '/home/yuexi/Documents/CPM/VideoResults/'; %linux
Batch = 2;
filePath = [fileRoot,'Batch',num2str(Batch),'/'];
%fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
resultName = ['video_track_pose_center_b',num2str(Batch),'.mat'];
fileName = fullfile([filePath,'/',resultName]);
load(fileName);
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
%addpath('~/Documents/CPM/testing');
addpath(genpath('~/Documents/LabLife/Reaserch/SpringforPhD/CPM/testing/'));
param = config();
%% Removing Outliers

order = 2;
lambda = 1;
numVid = 1;
CleanedTraj(1:length(video_track)) = struct('vidName',[],'traject',[]);
<<<<<<< HEAD
for Nvideo = 1 %: 5 %length(video_single)
=======
for Nvideo = numVid : length(video_track)
>>>>>>> c1ddbc8132eea2172f84aa12a9c141a70e37e5ac
   
    %videoPrediction = video_singleOnly_Result(Nvideo).prediction;
   Prediction = video_track(Nvideo).prediction;
   Rect = video_track(Nvideo).annorect;
   Traj(1:length(Rect)) = struct('trj',[]);
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
        clear NewTraj
    
    end
CleanedTraj(Nvideo).vidName = video_track(Nvideo).vidName;
CleanedTraj(Nvideo).traject = Traj;
clear Traj
end
%%
close all
%Picroot = '~/Desktop/videos/';
Picroot = '/Users/yuexizhang/Documents/Realtime/Video/';
%Picroot = '/media/yuexi/DATA/MPII_data/';
PicPath = [Picroot,num2str(Batch),'/'];
<<<<<<< HEAD
=======
%param = config();
>>>>>>> c1ddbc8132eea2172f84aa12a9c141a70e37e5ac
c = hsv(20);
%% comparing key images for raw data and cleaned data
clear MFV_test
figure
for Nvideo= numVid : length(CleanedTraj)
    imPath = [PicPath,video_track(Nvideo).vidName];
    imlist = dir(fullfile(imPath,'*.jpg'));
    keyframe = video_track(Nvideo).keyframe;
    keyInd = find(strcmp({imlist.name}, keyframe)==1);
    prediction = video_track(Nvideo).prediction;
    Traject = CleanedTraj(Nvideo).traject;
    compareTraj(1:length(prediction)) = struct('comp',[]);
    
     for nPerson = 1 : length(prediction)
        
        videoPrediction = prediction(nPerson).pred{1,keyInd};
        cleanedPrediction = Traject(nPerson).trj{1,keyInd};
        compareTracj(nPerson).comp{1,1} = videoPrediction;% origin data
        compareTracj(nPerson).comp{1,2} = cleanedPrediction; %cleaned data
  
     end
    
    
    Title = {'Original Detection','Cleaned Detection'};
    for i = 1 : 2
        
        subplot(2,1,i)
        hold off
        image = [imlist(keyInd).folder,'/',imlist(keyInd).name];
        img = imread(image);
        imshow(img)
        %title([num2str(keyInd),'/',num2str(length(imlist))]);
        title(['Video:',num2str(Nvideo),'  ',Title{1,i}]);
        hold on;
        for nPerson = 1 : length(prediction)
            
            visualizeSkeleton(compareTracj(nPerson).comp{1,i}, param);
            
            
%             currFrame = getframe;
%             writeVideo(vidObj, currFrame);
        end
     
    end
    MFV_test(Nvideo) = getframe(gcf);
    
    %my_frame2video(MFV_test,'comparison');
    
    pause(0.2);
    %}
   

<<<<<<< HEAD
for Nvideo = 1 %: 5
imPath = [PicPath,CleanedTraj(Nvideo).vidName]; 
=======
end
%% making video
for Nvideo = numVid %: 5
%imPath = [PicPath,CleanedTraj(Nvideo).vidName]; 
imPath = [PicPath,video_track(Nvideo).vidName];
>>>>>>> c1ddbc8132eea2172f84aa12a9c141a70e37e5ac
imlist = dir(fullfile(imPath,'*.jpg'));
keyframe = video_track(Nvideo).keyframe;
% addpath(genpath('testing'));
% load('../VideoResults/test.mat');
keyInd = find(strcmp({imlist.name}, keyframe)==1);
prediction = video_track(Nvideo).prediction;

 %Traject = CleanedTraj(Nvideo).traject;

    for i = 1 : length(imlist)
    
        %test_image = [imgPath,annolist_test_single(i).image.name];
        hold off
        test_image = [imlist(i).folder,'/',imlist(i).name];
        im = imread(test_image);
     
        imshow(im)
        title([num2str(i),'/',num2str(length(imlist))]);
        hold on;
<<<<<<< HEAD
        for nPerson = 1 : length(Traject)
=======
        for nPerson = 1 : length(prediction)
>>>>>>> c1ddbc8132eea2172f84aa12a9c141a70e37e5ac
            videoPrediction = Traject(nPerson).trj;
            %videoPrediction = prediction(nPerson).pred;
                %test_image = [imgPath,annolist_test_single(i).image.name];
            
            visualizeSkeleton(videoPrediction{1,i}, param);
            

                %MFV_test(i) = getframe(gcf);
   
        end
        pause;
    end

%my_frame2video(MFV_test,1,'video1_orig');
end
























