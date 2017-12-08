clear all
dbstop if error
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
addpath('~/Documents/CPM/testing');

%fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/'; % ios
%Picroot = '/Users/yuexizhang/Documents/Realtime/Video/'; %ios

fileRoot = '/home/yuexi/Documents/CPM/VideoResults/'; %linux
Picroot = '/media/yuexi/DATA/MPII_data/'; %linux
allBatch = 25;
%param = config();
%%
Result_single(1:allBatch) = struct('Batch',[]);
for Batch = 1 : 15  
    clear compareTraject cleanedTraject
    fprintf('Batch:%d/%d \n', Batch, allBatch);
    
    [cleanedTraject,video_track] = getcleanTraject(Batch, fileRoot);
    
    compareTraject = getCompareTrajact(cleanedTraject,video_track, Picroot,Batch);
    
   
    Result_single(Batch).Batch = compareTraject;
    save([fileRoot,'Result_MPII_single_part1.mat'],'Result_single');
    
end
fprintf('All Done!');


























