% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_s01a01r01_fps22.mat'));

% the indices of MHAD skeleton corresponding to the 2D skeleton
lut = [ 7 5 9 11 13 16 18 20 22 24 26 29 31 33 ];

%% get data
A = data(label_sub==1 & label_act==1 & label_rep==1);
% A = getVelocity(A);
ysTrain = A{1};

% system ID of 3D data
order = 4;
np = 14;
% nJoint = 35;
rs = zeros(order+1, 2*np);
for i = 1:2*np
    fprintf('Performation system ID %d/%d\n', i, 2*np);
    if mod(i,2)==1
        y = ysTrain(lut((i+1)/2)*3-2,:);
    else
        y = ysTrain(lut(i/2)*3,:);
    end
    [r1Train] = sysIdOneJoint(y, order);
    rs(:, i) = r1Train;
end

%% outlier cleaning
load(fullfile(rootPath, 'expData', 'mhad_pose_s01a01r01.mat'));
np = 14;
ysTest = zeros(np*2, length(detection));
for i = 1:length(detection)
    temp = detection{i}';
    ysTest(:, i) = temp(:);
end

nc = order+1;
lambda = 1e0;
lambda1 = 1e0;
lambda2 = 1e3;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    y = ysTest(i, :);
    % yc1_test = hstln_mo(y, order);
%     ind = ceil(i/2);
    ind = i;
%     [yHat] = sords_l2_lagrangian(y, rs(:,ind), nc, lambda);
    [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
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
    displayJointCompareInColor(im, yt, gt);
%     displayJointCompareInColor(im, yc, gt);
    pause;
end

%%
thres = 10;
acc = computeAccuracy(ysClean, gtJoint, thres);
acc
%% plot acc curve with 
accVectorSords = plotAccCurve(ysClean, gtJoint);
save(fullfile(rootPath,'expData','accVectorSords'), 'accVectorSords');