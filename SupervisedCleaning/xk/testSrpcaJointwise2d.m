% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));
dataPath = '~/research/data/MHAD';

np = 14;
visualize = 0;
visualize3 = 0;

nSub = 12;
nAct = 11;
accuracy = zeros(nAct, nSub);
for ai = 1:nAct
    for si = 1:nSub
        
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
        
        %% load ground truth file
        gtFile = fullfile(dataPath, 'mhad_gt', sprintf('gtJoint_s%02da%02dr%02d.mat',sInd,aInd,rInd));
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
        end
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

save(fullfile(rootPath,'expData','accuracySrpca2d'), 'accuracy', 'outlierThres');