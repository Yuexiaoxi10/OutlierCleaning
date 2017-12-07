fileRoot = '/home/yuexi/Documents/CPM/VideoResults/';
Picroot = '/media/yuexi/DATA/MPII_data/';
addpath('~/Documents/CPM/testing');
addpath(genpath('../../OutlierRemoving'));
param = config();

%load([fileRoot,'Result_MPII_single.mat']);

%%
for Batch = 1 %: 15
    clear compareTraject
    PicPath = [Picroot,num2str(Batch),'/'];
    
    
    compareTraject = Result_single(Batch).Batch;
    
    
    for Nvideo= 1 : length(compareTraject)
        figure(1)
        clear Traject_comp 
        imPath = [PicPath,compareTraject(Nvideo).vidName];
        imlist = dir(fullfile(imPath,'*.jpg'));
        keyframe = compareTraject(Nvideo).keyframe;
        keyInd = find(strcmp({imlist.name}, keyframe)==1);
        
        Traject_comp = compareTraject(Nvideo).traj;
        
        compareTraj = cell(length(Traject_comp),2);
        Title = {'Original Detection','Cleaned Detection'};
        for i = 1 : 2
            hold off
            subplot(2,1,i)
           
            image = [imlist(keyInd).folder,'/',imlist(keyInd).name];
            img = imread(image);
            imshow(img)
            
            %title([num2str(keyInd),'/',num2str(length(imlist))]);
            title(['Video:',num2str(Nvideo),'  ',Title{1,i}]);
            hold on;
            for nPerson = 1 : length(Traject_comp)
                compareTraj{nPerson,1} = Traject_comp(nPerson).origin;
                
                compareTraj{nPerson,2} = Traject_comp(nPerson).cleaned;
                
                
                visualizeSkeleton(compareTraj{nPerson,i}, param);
            
            
%             currFrame = getframe;
%             writeVideo(vidObj, currFrame);
            end
     
        end
        %MFV_test(Nvideo) = getframe(gcf);
    
        %my_frame2video(MFV_test,'comparison');
    
        pause(0.2);
    
   %}


    end
end

%% making video
for Nvideo = numVid %: 5
%imPath = [PicPath,CleanedTraj(Nvideo).vidName]; 
imPath = [PicPath,video_track(Nvideo).vidName];

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

        for nPerson = 1 : length(Traject)
            

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
