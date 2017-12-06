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
     
    
    %{
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


end