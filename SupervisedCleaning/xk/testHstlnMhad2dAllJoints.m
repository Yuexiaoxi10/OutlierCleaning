% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

np = 14;

%% load testing data
aInd = 11;
actPath = sprintf('A%02d', aInd);
load(fullfile(rootPath, 'expData', 'mhad_pose','S01',actPath,'R01','poseCPM.mat'));
ysTest = zeros(np*2, length(videoPrediction));
for i = 1:length(videoPrediction)
    temp = videoPrediction{i}';
    ysTest(:, i) = temp(:);
end

%% outlier cleaning
order = 6;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    y = ysTest(i, :);
    yHat = hstln_mo(y, order);
    ysClean(i, :) = yHat;
%     figure(1);
%     plot(y, 'x-');
%     hold on;
%     plot(yHat, 'o-');
%     title(sprintf('Test Instance %d',i));
%     hold off;
%     pause;
end

%% display
param = config();
model = param.model(param.modelID);
np = model.np;
% load image files
imgRootPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01';
imgPath = fullfile(imgRootPath, 'Cam01','S01',actPath, 'R01');
imgFile = dir(fullfile(imgPath, '*.pgm'));
% load pose file
posePath = fullfile(rootPath, 'expData', 'mhad_pose', 'S01', actPath, 'R01');
poseFile = fullfile(posePath, 'poseCPM.mat');
load(poseFile);
% load ground truth file
gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s01a%02dr01.mat',aInd));
load(gtFile);

for i = 1:length(videoPrediction)
    im = imread(fullfile(imgPath, imgFile(i).name));
%     wei_visualize(im, videoPrediction{i}, param);
    yt = reshape(ysTest(:, i), 2, []).';
    yc = reshape(ysClean(:, i), 2, []).';
    gt = reshape(gtJoint(:, i), 2, []).';
%     wei_visualize(im, y, param);
%     displayJointInColor(im, yc);
    displayJointCompareInColor(im, yt, gt);
%     displayJointCompareInColor(im, yc, gt);
    pause(0.1);
end

%%
thres = 10;
acc = computeAccuracy(ysClean, gtJoint, thres);
acc
%% plot acc curve with 
[accVectorHstln, aucHstln] = plotAccCurve(ysClean, gtJoint);
aucHstln
save(fullfile(rootPath,'expData','accVectorHstln2d'), 'accVectorHstln', 'aucHstln');
