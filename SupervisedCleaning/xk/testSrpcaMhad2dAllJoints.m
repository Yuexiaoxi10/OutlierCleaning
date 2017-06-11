% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

%% outlier cleaning
load(fullfile(rootPath, 'expData', 'mhad_pose_s01a01r01.mat'));
np = 14;
ysTest = zeros(np*2, length(detection));
for i = 1:length(detection)
    temp = detection{i}';
    ysTest(:, i) = temp(:);
end

lambda1 = 1e3;
lambda2 = 1e10;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    y = ysTest(i, :);
    yHat = SRPCA_e1_e2_clean_md(y', lambda1, lambda2, ones(size(y')));
    yHat = yHat';
    ysClean(i, :) = yHat;
%     figure(1);
%     plot(y, 'x-');
%     hold on;
%     plot(yHat, 'o-');
%     title(sprintf('Test Instance %d',i));
%     hold off;
%     pause;
end
e = ysClean-ysTest;
norm(e)

%% display

param = config();
model = param.model(param.modelID);
np = model.np;
imgPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01/Cam01/S01/A01/R01';
imgFile = dir(fullfile(imgPath, '*.pgm'));

% get pose detections
poseDir = fullfile('~', 'research', 'code', 'OutlierCleaning', 'expData');
poseFile = fullfile(poseDir, 'mhad_pose_s01a01r01.mat');
load(poseFile);
load gtJoint.mat
for i = 1:length(detection)
    im = imread(fullfile(imgPath, imgFile(i).name));
%     wei_visualize(im, detection{i}, param);
    yt = reshape(ysTest(:, i), 2, []).';
    yc = reshape(ysClean(:, i), 2, []).';
    gt = reshape(gtJoint(:, i), 2, []).';
%     wei_visualize(im, y, param);
%     displayJointInColor(im, yc);
%     displayJointCompareInColor(im, yt, yc);
    displayJointCompareInColor(im, yc, gt);
    pause(0.1);
end

%%
thres = 10;
acc = computeAccuracy(ysClean, gtJoint, thres);
acc
%% plot acc curve with 
accVectorSrpca = plotAccCurve(ysClean, gtJoint);
save(fullfile(rootPath,'expData','accVectorSrpca'), 'accVectorSrpca');
