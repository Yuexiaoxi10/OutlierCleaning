% show my demo results with Wei's code

clear; close all; dbstop if error;
% addpath(genpath('../../matlab'));
addpath(genpath('../../3rdParty'));

patchSize = 10;

%imgPath = fullfile('..','..','expData','Sample','036778313');
imgPath = fullfile('/Users/yuexizhang/Documents/Realtime/Video/1','036778313');
imgFile = dir(fullfile(imgPath,'*.jpg'));

% get pose detections
%poseFile = fullfile('..','..','expData','Sample','036778313.mat');
poseFile = fullfile('/Users/yuexizhang/Documents/Realtime/Realtime_Multi-Person_Pose_Estimation-master/Video_Results','036778313.mat');
load(poseFile);

nJ = 15;
% poseDetection = cell(1, length(poseFiles));
poseDetection(1:length(imgFile)) = struct('person',[]);
for i = 1:length(imgFile)
    prediction = Results(i).sub(:,1:nJ);
    candi = Results(i).candi;
    isAllDetected = all(prediction')';
    prediction = prediction(isAllDetected, :);
    if isempty(prediction)
        continue;
    end
    img = imread(fullfile(imgPath, imgFile(i).name));
    nPerson = size(prediction, 1);
    for k = 1:nPerson
        for j = 1:nJ
            xy = candi(prediction(k,j),1:2)';
            person(k).joint(j).xy = xy;
            person(k).joint(j).appr = getFeature(img, xy, patchSize);
%             pred = permute(prediction, [2 1 3]);
%             pred = reshape(pred, [], size(prediction, 3));
%             poseDetection{i} = pred;
        end
    end
    poseDetection(i).person = person;
end

% associate detection into tracklets
opt.costThres = 10000;
opt.lambda = 0.1;
poseTracklet = associatePose(poseDetection, opt);

% poseTrackletClean = cleanTracklet(poseTracklet);

% len = [poseTracklet.length];
% ind = find(len == max(len), 1);
% poseTrack = poseTracklet(ind);

% % associate short tracklets into longer tracks
% nFrame = length(poseFiles);
% poseTrack = associateTracklet(poseTrackletClean, np, nFrame);

poseTrack = poseTracklet;

% display the trackes superposed on video
displayPoseTrack(imgPath, poseTrack, false);