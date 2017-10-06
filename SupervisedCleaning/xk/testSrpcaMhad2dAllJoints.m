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

%% load ground truth file
gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
load(gtFile);

%% outlier cleaning
lambda1 = 20;
lambda2 = 1e10;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    fprintf('Performing SRPCA on Joint %d/%d\n', i, size(ysTest, 1));
    y = ysTest(i, :);
    yHat = SRPCA_e1_e2_clean_md(y', lambda1, lambda2, ones(size(y')));
    yHat = yHat';
    ysClean(i, :) = yHat;
    figure(1);
    plot(y, 'x-');
    hold on;
    plot(yHat, 'o-');
    title(sprintf('Test Instance %d',i));
    hold off;
    pause;
end
e = ysClean-ysTest;
norm(e)

%% display
if visualize
    param = config();
    model = param.model(param.modelID);
    np = model.np;
    imgRootPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01';
    imgPath = fullfile(imgRootPath, 'Cam01','S01',actPath, 'R01');
    imgFile = dir(fullfile(imgPath, '*.pgm'));
    % load ground truth file
    gtFile = fullfile(rootPath, 'expData', 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
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
thres = 10;
acc = computeAccuracy(ysClean, gtJoint, thres);
acc
%% plot acc curve with 
[accVectorSrpca, aucSrpca] = plotAccCurve(ysClean, gtJoint);
aucSrpca
save(fullfile(rootPath,'expData','accVectorSrpca2d'), 'accVectorSrpca', 'aucSrpca');
