clear all
dbstop if error
addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
%addpath('~/Documents/CPM/testing');%linux
addpath('/media/DATAPART1/yuexi/CPM/testing/');

%fileRoot = '/Users/yuexizhang/Documents/CPM/VideoResults/'; % ios
%Picroot = '/Users/yuexizhang/Documents/Realtime/Video/'; %ios

%fileRoot = '/home/yuexi/Documents/CPM/VideoResults/'; %linux
%Picroot = '/media/yuexi/DATA/MPII_data/'; %linux
fileRoot = '/media/DATAPART1/yuexi/CPM/VideoResults/'; %server
Picroot = '/media/DATAPART1/yuexi/Data/'; %server

allBatch = 25;
%param = config();
%%
Result_single(1:allBatch) = struct('Batch',[]);

for Batch = 16 : 25  
    clear compareTraject cleanedTraject 

    %for Batch = 1 : 15  
    %clear compareTraject cleanedTraject

    fprintf('Batch:%d/%d \n', Batch, allBatch);
    
    [cleanedTraject,video_track] = getcleanTraject(Batch, fileRoot);
    
    compareTraject = getCompareTrajact(cleanedTraject,video_track, Picroot,Batch);
    
   
    Result_single(Batch).Batch = compareTraject;

    save([fileRoot,'Result_MPII_single.mat'],'Result_single');
    %save([fileRoot,'Result_MPII_single_part2.mat'],'Result_single');

    
    
end
fprintf('All Done!');


























