% test real data, MHAD as example

clear; close all;
dbstop if error

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/JHMDB';
posePath = 'jhmdb_pose_cpm';
poseName = 'poseCPM.mat';
% posePath = 'jhmdb_pose_pdcpm';
% poseName = 'posePDCPM.mat';
% posePath = 'jhmdb_pose_mpe';
% poseName = 'poseMPE.mat';

% the indices of MHAD skeleton corresponding to the 2D skeleton
lut = [3, 1, 4, 8, 12, 5, 9, 13, 6, 10, 14, 7, 11, 15];
np = 14;

visualize = 0;
visualize3 = 0;


action = {'swing_baseball'};
for ai = 1:length(action)
    video = listFolder(fullfile(dataPath, posePath, action{ai}));
    accuracy = zeros(1, length(video));
    aucAll = zeros(1, length(video));
    for vi = 1:length(video)
%     for vi = 1
        
        %% load testing data
        load(fullfile(dataPath, posePath, action{ai}, video{vi}, poseName));
        ysTest = zeros(np*2, length(videoPrediction));
        for i = 1:length(videoPrediction)
            if isempty(videoPrediction{i}), continue; end
            temp = videoPrediction{i}(1:np, 1:2)';
            ysTest(:, i) = temp(:);
        end
        
        %% outlier cleaning
        lambda1 = 20;
        lambda2 = 1e10;
        ysClean = zeros(size(ysTest));
        for i = 1:size(ysTest, 1)
            fprintf('Performing SRPCA on Joint %d/%d\n', i, size(ysTest, 1));
            y = ysTest(i, :);
            if ~any(y), continue; end
            omega = ones(1, size(y, 2)); omega(y==0) = 0;
            yHat = SRPCA_e1_e2_clean_md(y', lambda1, lambda2, omega');
            yHat = yHat';
            ysClean(i, :) = yHat;
        end
        
        %% load ground truth file
        gtFile = fullfile(dataPath, 'joint_positions', action{ai}, video{vi}, 'joint_positions.mat');
        load(gtFile);
        gtJoint = reshape(pos_img(:,lut,:), 2*np, []);
        
        %% display results
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
        
        %% display
        
        if visualize
            param = config();
            model = param.model(param.modelID);
            np = model.np;
            imgRootPath = fullfile(dataPath, 'images');
            imgPath = fullfile(imgRootPath, action{ai},video{vi});
            imgFile = dir(fullfile(imgPath, '*.png'));
            for i = 1:length(imgFile)
                im = imread(fullfile(imgPath, imgFile(i).name));
                yt = reshape(ysTest(:, i), 2, []).';
                yc = reshape(ysClean(:, i), 2, []).';
                gt = reshape(gtJoint(:, i), 2, []).';
                %         displayJointInColor(im, yt);
                %         displayJointCompareInColor(im, yt, gt);
                displayJointCompareInColor(im, yc, gt);
                pause;
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
        accuracy(ai, vi) = acc;
        
        % compute AUC
        [accVector, auc] = plotAccCurve(ysClean, gtJoint);
        aucAll(ai, vi) = auc;
    end
end
aucAvg = mean(aucAll);
save(fullfile(rootPath,'expData','accuracyJhmdbSrpca'), 'accuracy', 'outlierThres', 'aucAll', 'aucAvg');
