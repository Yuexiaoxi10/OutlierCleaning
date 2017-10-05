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
    
    %% load training data
    load(fullfile(dataPath, 'joint_positions', action{ai}, 'BaseballSwingAnalysis_swing_baseball_f_nm_np1_fr_med_8', 'joint_positions.mat'));
    ysTrain = reshape(pos_img(:,lut,:), 2*np, []);
    
    %% system ID of training data
    orderUpperBound = 3;
    rs = cell(1, np);
    % rs = cell(1, 2*np);
    for i = 1:length(rs)
        fprintf('Performing system ID %d/%d\n', i, length(rs));
        %     [r1Train] = sysIdOneJoint(ysTrain(i, 1:15), 5);
        %     rs(:, i) = r1Train;
        [r1Train] = sysIdSvd(ysTrain(2*i-1:2*i, :), orderUpperBound);
        %     r1Train = sysIdSvd(ysTrain(i, :), orderUpperBound);
        rs{i} = r1Train;
    end
    
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
        %% load ground truth file
        gtFile = fullfile(dataPath, 'joint_positions', action{ai}, video{vi}, 'joint_positions.mat');
        load(gtFile);
        gtJoint = reshape(pos_img(:,lut,:), 2*np, []);
        
        %% outlier cleaning
        lambda = 1e4;
        lambda1 = 1e0;
        lambda2 = 1;
        ysClean = zeros(size(ysTest));
        % for i = 1:np
        for i = 1:np*2
            % for i = 7
            fprintf('Performing SORDS on Joint %d/%d\n', i, np*2);
            %     y = ysTest(2*i-1:2*i, :);
            y = ysTest(i, :);
            if ~any(y), continue; end
            ind = ceil(i/2);
            %     ind = i;
            %     [omega, residue, cnt] = outlierDetectionSords(y, rs{ind}, 30);
            omega = ones(1, size(y, 2)); omega(y==0) = 0;
            %     [omega, residue, cnt] = outlierDetectionS2R3(y);
            [yHat] = sords_l1_lagrangian_md(y, rs{ind}, lambda, omega);
            %     [omega, residue, cnt] = outlierDetectionSords(y(1,:), rs{i}, 10);
            %     [omega, x] = outlierDetectionPropagation(y, rs{ind}, 30);
            %             [yHat] = sords_l1_lagrangian_md(y, rs{ind}, lambda);
            %         [yHat] = sords_l1_lagrangian(y, rs{ind}, lambda);
            %     [yHat] = sords_l1l2_lagrangian(y, rs(:,ind), nc, lambda1, lambda2);
            %     ysClean(2*i-1:2*i, :) = yHat;
            ysClean(i, :) = yHat;
        end
        
        %% display results
        if visualize3
            figure(3);
            for i = 1:size(ysTest, 1)
                %     for i = 13:16
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
save(fullfile(rootPath,'expData','accuracyJhmdbSords'), 'accuracy', 'outlierThres', 'aucAll', 'aucAvg');
