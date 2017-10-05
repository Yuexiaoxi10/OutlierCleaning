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
for i = 1:length(imgFiles)
% for i = 1:50  
    im = imread(fullfile(imgPath, imgFiles(i).name));
    predict = [];
    index = [];
    for k = 1:length(poseTrack)
        idx = i - poseTrack(k).tStart + 1;
        if idx < 1 || idx > poseTrack(k).length
            pred = [];
        else
            pred = poseTrack(k).traj(:, idx);
            pred = reshape(pred, 2, [])';
            predict = cat(3, predict, pred);
            index = [index, k];
        end
    end
    if isempty(predict)
        continue;
    end
    wei_visualize(im, predict, param)
    dispBbox(predict, index);
    
    if saveVideo
        currFrame = getframe;
        writeVideo(vidObj, currFrame);
    end
    title(sprintf('Frame %d', i));
    pause(0.1);
end

if saveVideo
    close(vidObj);
end

end