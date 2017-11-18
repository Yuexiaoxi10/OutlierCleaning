function displayPoseTrack(imgPath, poseTrack, saveVideo)
% display pose tracks

if nargin < 3
    saveVideo = false;
end

addpath(genpath('.'));
param = config();

if saveVideo
    vidObj = VideoWriter('myData', 'MPEG-4');
    vidObj.FrameRate = 5;
    open(vidObj);
end

imgFiles = dir([imgPath '/*.jpg']);
c = hsv(20);

for i = 1:length(imgFiles)
%for i = 1:50
     i
    im = imshow(imread(fullfile(imgPath, imgFiles(i).name))),hold on;
    predict = [];
    index = [];
    for k = 1:length(poseTrack)
        idx = i - poseTrack(k).tStart + 1;
        if idx < 1 || idx > poseTrack(k).length
            pred = [];
        else
            pred = poseTrack(k).traj(:, idx);
            % show trajectory
            plot(poseTrack(k).traj(1, max(1,idx-15):idx),...
                poseTrack(k).traj(2, max(1,idx-15):idx),...
                '-', 'color', c(mod(k,20)+1,:),'LineWidth',1.5);
            pred = reshape(pred, 2, [])';
            predict = cat(3, predict, pred);
            index = [index, k];
        end
    end
    if isempty(predict)
        continue;
    end
%     wei_visualize(im, predict, param)
   
     
     dispBbox(predict, index);
    
    if saveVideo
        currFrame = getframe;
        writeVideo(vidObj, currFrame);
    end
    title(sprintf('Frame %d', i));
%     MFV(i) = getframe(gcf);
    pause(0.2);
%     pause;
end

if saveVideo
    close(vidObj);
end
%  my_frame2video(MFV);

end