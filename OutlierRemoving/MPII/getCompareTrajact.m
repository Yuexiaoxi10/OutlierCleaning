function compareTraject = getCompareTrajact(cleanedTraject,video_track, Picroot,Batch)
close all
%Picroot = '~/Desktop/videos/';


PicPath = [Picroot,num2str(Batch),'/'];

%param = config();
c = hsv(20);
compareTraject(1 : length(cleanedTraject)) = struct('traj',[],'keyframe',[]);
%% comparing key images for raw data and cleaned data
%clear MFV_test
%figure
for Nvideo= 1 : length(cleanedTraject)
    clear Traject comTraj 
    %fprintf('video:%d/%d \n',Nvideo,length(cleanedTraject));
    
    %imPath = [PicPath,video_track(Nvideo).vidName];
    imPath = [PicPath,cleanedTraject(Nvideo).vidName];
    imlist = dir(fullfile(imPath,'*.jpg'));
    keyframe = video_track(Nvideo).keyframe;
    keyInd = find(strcmp({imlist.name}, keyframe)==1);
    prediction = video_track(Nvideo).prediction;
    Traject = cleanedTraject(Nvideo).traject;
    %compareTraj(1:length(prediction)) = struct('comp',[]);
    
     for nPerson = 1 : length(prediction)
        
        videoPrediction = prediction(nPerson).pred{1,keyInd};
        cleanedPrediction = Traject(nPerson).trj{1,keyInd};
        comTraj(nPerson).origin = videoPrediction;% origin data
        comTraj(nPerson).cleaned = cleanedPrediction; %cleaned data
  
     end
     compareTraject(Nvideo).traj = comTraj;
     compareTraject(Nvideo).keyframe = video_track(Nvideo).keyframe;
     compareTraject(Nvideo).vidName = video_track(Nvideo).vidName;
end