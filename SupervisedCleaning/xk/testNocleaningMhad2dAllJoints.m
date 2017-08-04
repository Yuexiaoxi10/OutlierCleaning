% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

np = 14;
visualize = 1;

%% load testing data
sInd = 2;
aInd = 11;
rInd = 1;
subPath = sprintf('S%02d', sInd);
actPath = sprintf('A%02d', aInd);
repPath = sprintf('R%02d', rInd);
load(fullfile(rootPath, 'expData', 'mhad_pose',subPath,actPath,repPath,'poseCPM.mat'));
ysTest = zeros(np*2, length(videoPrediction));
for i = 1:length(videoPrediction)
    temp = videoPrediction{i}';
    ysTest(:, i) = temp(:);
end
ysClean = ysTest;

%% load ground truth file
gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
load(gtFile);

%% display results
% figure(1);
% for i = 1:size(ysTest, 1)
%     if visualize==0, break; end
%     plot(ysTest(i,:), 'x-');
%     hold on;
%     plot(ysClean(i,:), 'o-');
%     plot(gtJoint(i,:), '>--');
%     title(sprintf('Test Instance %d',i));
%     hold off;
%     pause;
% end

%% display
param = config();
model = param.model(param.modelID);
np = model.np;
% load image files
imgRootPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01';
imgPath = fullfile(imgRootPath, 'Cam01','S01',actPath, 'R01');
imgFile = dir(fullfile(imgPath, '*.pgm'));
% load pose file
posePath = fullfile(rootPath, 'expData', 'mhad_pose', subPath, actPath, repPath);
poseFile = fullfile(posePath, 'poseCPM.mat');
load(poseFile);
% load ground truth file
gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
load(gtFile);

for i = 1:length(videoPrediction)
    im = imread(fullfile(imgPath, imgFile(i).name));
%     wei_visualize(im, videoPrediction{i}, param);
    yt = reshape(ysTest(:, i), 2, []).';
    gt = reshape(gtJoint(:, i), 2, []).';
%     wei_visualize(im, y, param);
%     displayJointInColor(im, yc);
    displayJointCompareInColor(im, yt, gt);
%     displayJointCompareInColor(im, yc, gt);
    pause(0.1);
end

%%
thres = 10;
acc = computeAccuracy(ysTest, gtJoint, thres);

%% plot acc curve with 
[accVectorNoCleaning, aucNoCleaning] = plotAccCurve(ysTest, gtJoint);
aucNoCleaning
save(fullfile(rootPath,'expData','accVectorNoCleaning2d'), 'accVectorNoCleaning', 'aucNoCleaning');
