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
visualize = false;

nSub = 12;
nAct = 11;
accuracy = zeros(nAct, nSub);

c = 30;
% for ai = 1:nAct
% for si = 1:nSub
for ai = 3
for si = 2
% for si = 7
%% load training data
sInd = si - 1; if sInd==0, sInd=nSub; end
% sInd = si;
aInd = ai;
rInd = 1;
% ysTrain = data{label_sub==sInd & label_act==aInd & label_rep==rInd};
% % A = getVelocity(A);
% ysTrain = A{1};

gtFile = fullfile(dataPath, 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
load(gtFile);
ysTrain = gtJoint;
ysTrain = ysTrain(:, c+1:end-c);

% sInd = 2;
% aInd = 11;
% rInd = 1;
% subPath = sprintf('S%02d', sInd);
% actPath = sprintf('A%02d', aInd);
% repPath = sprintf('R%02d', rInd);
% load(fullfile(rootPath, 'expData', 'mhad_pose',subPath,actPath,repPath,'poseCPM.mat'));
% ysTrain = zeros(np*2, length(videoPrediction));
% for i = 1:length(videoPrediction)
%     temp = videoPrediction{i}';
%     ysTrain(:, i) = temp(:);
% end

%% system ID of training data
% order = 4;
rs = cell(1, 2*np);
for i = 1:length(rs)
% for i = 7
    fprintf('Performing system ID %d/%d\n', i, length(rs));
%     [r1Train] = sysIdOneJoint(ysTrain(i, 1:15), 5);
%     rs(:, i) = r1Train;
    [r1Train] = sysIdSvd(ysTrain(i, :), 3);
%     r1Train = sysIdSvd(ysTrain(i, 1:15), 3);
    rs{i} = r1Train;
end

%% load testing data
sInd = si;
aInd = ai;
rInd = 1;
subPath = sprintf('S%02d', sInd);
actPath = sprintf('A%02d', aInd);
repPath = sprintf('R%02d', rInd);
load(fullfile(dataPath, 'mhad_pose',subPath,actPath,repPath,'poseCPM.mat'));
ysTest = zeros(np*2, length(videoPrediction));
for i = 1:length(videoPrediction)
    temp = videoPrediction{i}';
    ysTest(:, i) = temp(:);
end
ysTest = ysTest(:, c+1:end-c);

%% load ground truth file
gtFile = fullfile(dataPath, 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
load(gtFile);
gtJoint = gtJoint(:, c+1:end-c);

%% outlier cleaning
% nc = order+1;
lambda = 1e6;
lambda1 = 1e0;
lambda2 = 1;
ysClean = zeros(size(ysTest));
% for i = 1:np
for i = 1:size(ysTest, 1)
% for i = 7
    fprintf('Performing SORDS on Joint %d/%d\n', i, size(ysTest, 1));
%     y = ysTest(2*i-1:2*i, :);
    y = ysTest(i, :);
    % yc1_test = hstln_mo(y, order);
%     ind = ceil(i/2);
    [omega, residue, cnt] = outlierDetectionSords(y, rs{i}, 10);
%     [omega, residue, cnt] = outlierDetectionS2R3(y);
%     [yHat] = sords_l1_lagrangian_md(y, rs{i}, lambda, omega);
%     [omega, residue, cnt] = outlierDetectionSords(y(1,:), rs{i}, 10);
%     [omega, x] = outlierDetectionPropagation(y, rs{ind}, 30);
    [yHat] = sords_l1_lagrangian_md(y, rs{i}, lambda, omega);
%     yHat = sords_nuc_l1_lagrangian_md(y, rs{i}, lambda, lambda2);
%     [yHat] = sords_l1_lagrangian(y, rs{i}, lambda);
%     [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
%     ysClean(2*i-1:2*i, :) = yHat;
    ysClean(i, :) = yHat;
%     ysClean(i, :) = x;
end
% e = ysClean-ysTest;
% norm(e)

%% display results
if visualize
figure(1);
for i = 1:size(ysTest, 1)
    if visualize==0, break; end
    plot(ysTest(i,:), 'x-');
    hold on;
    plot(ysClean(i,:), 'o-');
    plot(gtJoint(i,:), '>--');
    title(sprintf('Test Instance %d',i));
    hold off;
    pause;
end
end

%% display
if visualize
    param = config();
    model = param.model(param.modelID);
    np = model.np;
    imgRootPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01';
    imgPath = fullfile(imgRootPath, 'Cam01','S01',actPath, 'R01');
    imgFile = dir(fullfile(imgPath, '*.pgm'));
    % load ground truth file
    gtFile = fullfile(dataPath, 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
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
end

%%
outlierThres = 30;
o1 = zeros(size(gtJoint));
o2 = zeros(size(gtJoint));
o1(abs(ysTest-gtJoint) > outlierThres) = 1;
o2(abs(ysClean-gtJoint) > outlierThres) = 1;
% [prec, rec] = evalPrecRec(gtJoint, ysTest, ysClean, outlierThres);
acc = (nnz(o1==1 & o2~=1)+eps) / (nnz(o1==1) + eps);
acc
accuracy(ai, si) = acc;
end
end

save accuracy accuracy outlierThres