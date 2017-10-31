fileRoot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/CPM/VideoResults/';
Batch = 1;
filePath = [fileRoot,'Batch',num2str(Batch),'/'];
fileName = fullfile(filePath,['Results_Batch',num2str(Batch),'.mat']);
load(fileName);
%%
order = 2;
lambda = 0.2;

for Nvideo = 7 %: length(video_single)
    
   videoPrediction = video_single(Nvideo).Results;
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
    
end

NewTracj = cell(1,frame);
pose = zeros(np,2);
for i = 1 : frame
    
   
    for j = 1 : np
        joint = Trajec_new{1,j}(:,i);
        pose(j,:) = joint';
       
        
    end
    
    NewTracj{1,i} = pose;
    
end


Picroot = '/Users/zhangyuexi/Documents/LabLife/Reaserch/SpringforPhD/MPII_videos/Batch1_single/';

close all
%dbstop if error
% for vid = 1 : 10
imPath = [Picroot,video_single(Nvideo).vidName]; 
imlist = dir(fullfile(imPath,'*.jpg'));
% addpath(genpath('testing'));
% load('../VideoResults/test.mat');

%  videoPrediction = video_single(Nvideo).Results;
  videoPrediction = NewTracj;
 
for i = 1 : length(videoPrediction)
    
%test_image = [imgPath,annolist_test_single(i).image.name];
test_image = [imlist(i).folder,'/',imlist(i).name];
visualizeSkeleton(test_image, videoPrediction{1,i}, param);
title([num2str(i),'/', num2str(frame)]);

%MFV_test(i) = getframe(gcf);
%     
% pause(0.05);
pause;

end
%my_frame2video(MFV_test,1,'video');
% end



