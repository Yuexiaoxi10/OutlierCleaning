% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_fps22.mat'));

% the indices of MHAD skeleton corresponding to the 2D skeleton
lut = [ 7 5 9 11 13 16 18 20 22 24 26 29 31 33 ];
np = 14;

%% get data
% A = data{label_sub==1 & label_act==11 & label_rep==1};
% A = getVelocity(A);
% ysTrain = zeros(2*np, size(A, 2));
% for i = 1:2*np
%     if mod(i,2)==1
%         ysTrain(i, :) = A(lut((i+1)/2)*3-2,:);
%     else
%         ysTrain(i, :) = A(lut(i/2)*3,:);
%     end
% end

aInd = 11;
gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s01a%02dr01.mat',aInd));
load(gtFile);
ysTrain = gtJoint;
% vsTrain = diff(ysTrain, [], 2);
% step = 3;
% vsTrain = getVel(ysTrain, step);

%% system ID of 2D data
order = 4;
% nJoint = 35;
rs = cell(1, 2*np);
for i = 1:2*np
% for i = 18
    fprintf('Performing system ID %d/%d\n', i, 2*np);
%     [r1Train] = sysIdOneJoint(ysTrain(i, :), order);
%     [r1Train] = sysIdOneJoint(ysTrain(i,:)-ysTrain(i,1), order);
    [r1Train] = sysIdSvd(ysTrain(i, :));
%     [r1Train] = sysIdSvd(vsTrain(i, :));
    rs{i} = r1Train;
end

%% outlier cleaning
aInd = 11;
actPath = sprintf('A%02d', aInd);
load(fullfile(rootPath, 'expData', 'mhad_pose','S01',actPath,'R01','poseCPM.mat'));
np = 14;
ysTest = zeros(np*2, length(videoPrediction));
for i = 1:length(videoPrediction)
    temp = videoPrediction{i}';
    ysTest(:, i) = temp(:);
end

nc = order+1;
lambda = 1e6;
lambda1 = 1e0;
lambda2 = 1e3;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    y = ysTest(i, :);
    % yc1_test = hstln_mo(y, order);
%     ind = ceil(i/2);
    ind = i;
%     offset = y(1);
    [yHat] = sords_l1_lagrangian(y, rs{i}, lambda);
%     yHat = yHat + offset;
%     [yHat] = sords_vel_l1_lagrangian(y, rs{i}, step, lambda);
%     [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
    ysClean(i, :) = yHat;
    figure(1);
    plot(y, 'x-');
    hold on;
    plot(yHat, 'o-');
    plot(gtJoint(i,:), '>--');
    title(sprintf('Test Instance %d',i));
    hold off;
    pause;
end
e = ysClean-ysTest;
norm(e)

%% display
param = config();
model = param.model(param.modelID);
np = model.np;
imgRootPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01';
imgPath = fullfile(imgRootPath, 'Cam01','S01',actPath, 'R01');
imgFile = dir(fullfile(imgPath, '*.pgm'));

% get pose videoPredictions
posePath = fullfile(rootPath, 'expData', 'mhad_pose', 'S01', actPath, 'R01');
poseFile = fullfile(posePath, 'poseCPM.mat');
load(poseFile);
% gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s01a%02dr01.mat',aInd));
% load(gtFile);
for i = 1:length(videoPrediction)
    im = imread(fullfile(imgPath, imgFile(i).name));
%     wei_visualize(im, videoPrediction{i}, param);
    yt = reshape(ysTest(:, i), 2, []).';
    yc = reshape(ysClean(:, i), 2, []).';
    gt = reshape(gtJoint(:, i), 2, []).';
%     wei_visualize(im, y, param);
%     displayJointInColor(im, yc);
    displayJointCompareInColor(im, yt, yc);
%     displayJointCompareInColor(im, yc, gt);
    pause(0.1);
end

%%
thres = 10;
acc = computeAccuracy(ysClean, gtJoint, thres);
acc
%% plot acc curve with 
[accVectorSords, aucSords] = plotAccCurve(ysClean, gtJoint);
aucSords
save(fullfile(rootPath,'expData','accVectorSords2d'), 'accVectorSords', 'aucSords');