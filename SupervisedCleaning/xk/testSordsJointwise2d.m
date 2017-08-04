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
visualize = 0;
visualize3 = 0;

%% load training data
sInd = 1;
aInd = 11;
rInd = 1;
ysTrain = data{label_sub==sInd & label_act==aInd & label_rep==rInd};
% A = getVelocity(A);
% ysTrain = A{1};

%% system ID of training data
% order = 4;
orderUpperBound = 3;
rs = cell(1, np);
for i = 1:np
% for i = 7
    fprintf('Performing system ID %d/%d\n', i, np);
%     [r1Train] = sysIdOneJoint(ysTrain(i, 1:15), 5);
%     rs(:, i) = r1Train;
    [r1Train] = sysIdSvd(ysTrain(3*lut(i)-2:3*lut(i), :), orderUpperBound);
%     r1Train = sysIdSvd(ysTrain(i, 1:15), 3);
    rs{i} = r1Train;
end

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
% lambdaList = 10.^(2:1:8);
lambdaList = 1e4;
ysCleanAll = cell(1, length(lambdaList));
for j = 1:length(lambdaList)
    lambda = lambdaList(j);
    % lambda = 1e4;
    lambda1 = 1e0;
    lambda2 = 1;
    ysClean = zeros(size(ysTest));
    for i = 1:np
        % for i = 7
        fprintf('Performing SORDS on Joint %d/%d\n', i, np);
        y = ysTest(2*i-1:2*i, :);
        %     y = ysTest(i, :);
        % yc1_test = hstln_mo(y, order);
        %     ind = ceil(i/2);
        ind = i;
        [omega, residue, cnt] = outlierDetectionSords(y, rs{i}, 30);
        %     [omega, residue, cnt] = outlierDetectionS2R3(y);
        [yHat] = sords_l1_lagrangian_md(y, rs{i}, lambda, omega);
        %     [omega, residue, cnt] = outlierDetectionSords(y(1,:), rs{i}, 10);
        %     [omega, x] = outlierDetectionPropagation(y, rs{ind}, 30);
%         [yHat] = sords_l1_lagrangian_md(y, rs{ind}, lambda);
        %     [yHat] = sords_l1_lagrangian(y, rs{i}, lambda);
        %     [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
        ysClean(2*i-1:2*i, :) = yHat;
    end
    ysCleanAll{j} = ysClean;
    % display results
    if visualize3
        figure(3);
        for i = 1:size(ysTest, 1)
            plot(ysTest(i,:), 'x-');
            hold on;
            plot(ysClean(i,:), 'o-');
            plot(gtJoint(i,:), '>--');
            title(sprintf('Test Instance %d',i));
            hold off;
            pause;
        end
    end
end




%% PR curve
outlierThres = 10;
prec = zeros(1, length(ysCleanAll));
rec = zeros(1, length(ysCleanAll));
for j = 1:length(ysCleanAll)
    [prec(j), rec(j)] = evalPrecRec(gtJoint, ysTest, ysCleanAll{j}, outlierThres);
end
if visualize
    figure(4);
    plot(prec, rec, '*-');
    title('PR curve');
    xlabel('Precision');
    ylabel('Recall');
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
%% plot acc curve with 
[accVectorSords, aucSords] = plotAccCurve(ysClean, gtJoint);
aucSords
save(fullfile(rootPath,'expData','accVectorSords2d'), 'accVectorSords', 'aucSords');



