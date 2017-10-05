% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_fps22.mat'));
np = 35;

%% get data
ysTrain = data{label_sub==1 & label_act==11 & label_rep==1};

%% load testing data, add synthetic outliers
ysTest = data{label_sub==2 & label_act==11 & label_rep==1};
gtJoint = ysTest;
[d, n] = size(ysTest);
rng('default');
nOutlier = round(0.3 * size(ysTest, 2));
xMin = min(min(ysTest(1:3:end,:)));
xMax = max(max(ysTest(1:3:end,:)));
yMin = min(min(ysTest(2:3:end,:)));
yMax = max(max(ysTest(2:3:end,:)));
zMin = min(min(ysTest(3:3:end,:)));
zMax = max(max(ysTest(3:3:end,:)));
for i = 1:np
    index = randi(n, 1, nOutlier);
    ysTest((i-1)*3+1,index) = xMin + (xMax-xMin)*rand(1,nOutlier);
    ysTest((i-1)*3+2,index) = xMin + (xMax-xMin)*rand(1,nOutlier);
    ysTest((i-1)*3+3,index) = xMin + (xMax-xMin)*rand(1,nOutlier); 
end

%% outlier cleaning
% order = 6;
ysClean = zeros(size(ysTest));
for i = 1:size(ysTest, 1)
    y = ysTest(i, :);
    H = blockHankel(y-mean(y));
    order = rankEst(H, 0.9);
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
e = ysClean-ysTest;
norm(e)

%%
thres = 10;
acc = computeAccuracy3d(ysClean, gtJoint, thres);
%% plot acc curve with 
[accVectorHstln, aucHstln] = plotAccCurve3d(ysClean, gtJoint);
aucHstln
save(fullfile(rootPath,'expData','accVectorHstln3d'), 'accVectorHstln', 'aucHstln');
