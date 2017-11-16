% show my demo results with Wei's code

clear; close all; 
%dbstop if error;
% addpath(genpath('../../matlab'));
addpath(genpath('../../3rdParty'));
Batch = 1;
patchSize = 10;
 % video number
%imgPath = fullfile('..','..','expData','Sample','036778313');
%/Users/yuexizhang/Documents/Realtime/Video/1/019871568
resultRoot = '/Users/yuexizhang/Documents/Realtime/Realtime_Multi-Person_Pose_Estimation-master/Video_Results/';
load([resultRoot,'Batch',num2str(Batch),'/','Result_Batch',num2str(Batch),'.mat']);

imgRoot = '/Users/yuexizhang/Documents/Realtime/Video/'; 
%%

k = 3;
imgPath = [imgRoot,num2str(Batch),'/',video1_multi(k).vidName,'/'];
imgFile = dir(fullfile(imgPath,'*.jpg'));
% get pose detections
%poseFile = fullfile('..','..','expData','Sample','036778313.mat');

% load(poseFile);

nJ = 15;

Results = video1_multi(k).Results;
% poseDetection = cell(1, length(poseFiles));
poseDetection(1:length(imgFile)) = struct('person',[]);
for i = 1:length(imgFile)
    prediction = Results(i).subset(:,1:nJ);
    candidates = Results(i).candidates;
    %isAllDetected = all(prediction')';
    %prediction = prediction(isAllDetected, :);
%     if isempty(prediction)
%         continue;
%     end
    img = imread(fullfile(imgPath, imgFile(i).name));
    nPerson = size(prediction, 1);
    for k = 1:nPerson
        for j = 1:nJ
            xy = candidates(prediction(k,j),1:2)';
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