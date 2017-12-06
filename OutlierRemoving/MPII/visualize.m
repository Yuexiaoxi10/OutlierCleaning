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
