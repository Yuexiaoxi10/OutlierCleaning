% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_fps22.mat'));

visualize = 0;

%% load training data
ysTrain = data{label_sub==1 & label_act==11 & label_rep==1};

%% system ID of 3D data
order = 4;
np = 35;
rs = cell(1, np);
for i = 1:np
    fprintf('Performing system ID on Joint %d/%d\n', i, np);
    y = ysTrain(3*i-2:3*i, :);
%     [r1Train] = sysIdOneJoint(y, order);
    [r1Train] = sysIdSvd(y);
    rs{i} = r1Train;
end

%% load testing data, add synthetic outliers
ysTest = data{label_sub==2 & label_act==11 & label_rep==1};
gtJoint = ysTest;
[d, n] = size(ysTest);
rng('default');
% nOutlier = round(0.3 * size(ysTest, 2));
nOutlier = 10;
xMin = min(min(ysTest(1:3:end,:)));
xMax = max(max(ysTest(1:3:end,:)));
yMin = min(min(ysTest(2:3:end,:)));
yMax = max(max(ysTest(2:3:end,:)));
zMin = min(min(ysTest(3:3:end,:)));
zMax = max(max(ysTest(3:3:end,:)));
for i = 1:np
%     index = randi(n, 1, nOutlier);
    start = randi(n-nOutlier+1);
    index = (start:start+nOutlier-1);
    ysTest((i-1)*3+1,index) = xMin + (xMax-xMin)*rand(1,nOutlier);
    ysTest((i-1)*3+2,index) = xMin + (xMax-xMin)*rand(1,nOutlier);
    ysTest((i-1)*3+3,index) = xMin + (xMax-xMin)*rand(1,nOutlier); 
end

%% outlier cleaning
nc = order+1;
lambda = 1e1;
lambda1 = 1e0;
lambda2 = 1e3;
ysClean = zeros(size(ysTest));
for i = 1:np
% for i = 5
    fprintf('Performing SORDS on Joint %d/%d\n', i, np);
    y = ysTest(3*i-2:3*i, :);
    % yc1_test = hstln_mo(y, order);
%     ind = ceil(i/3);
    ind = i;
    [omega, residue, cnt] = outlierDetectionSords(y, rs{ind}, 5);
    [yHat] = sords_l1_lagrangian_md(y, rs{ind}, lambda, omega);
%     [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
    ysClean(3*i-2:3*i, :) = yHat;
end
e = ysClean-ysTest;
norm(e)

%% display results
figure(1);
for i = 1:size(ysTest, 1)
    if visualize==0, break; end
    plot(ysTest(i,:), 'x-');
    hold on;
    plot(ysClean(i,:), 'o-');
    title(sprintf('Test Instance %d',i));
    hold off;
    pause;
end

%%
thres = 10;
acc = computeAccuracy3d(ysClean, gtJoint, thres);
%% plot acc curve with 
[accVectorSords, aucSords] = plotAccCurve3d(ysClean, gtJoint);
aucSords
save(fullfile(rootPath,'expData','accVectorSords3d'), 'accVectorSords', 'aucSords');