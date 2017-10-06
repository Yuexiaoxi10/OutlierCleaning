% explore JHMDB joints dynamics

clear; close all;
dbstop if error

rootPath = '~/research/code/OutlierCleaning';
addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/JHMDB';

% the indices of MHAD skeleton corresponding to the 2D skeleton
lut = [3, 1, 4, 8, 12, 5, 9, 13, 6, 10, 14, 7, 11, 15];
np = 14;
orderUpperBound = 3;

visualize = 0;
visualize3 = 0;

rs = cell(1, 1000);
count = 1;
action = listFolder(fullfile(dataPath, 'ReCompress_Videos'));
% action = {'swing_baseball'};
% for ai = 1:length(action)
for ai = 3:4
    video = dir(fullfile(dataPath, 'ReCompress_Videos', action{ai}, '*.avi'));
    
    for vi = 1:length(video)
        [~, vidName, ~] = fileparts(video(vi).name);
        %% load ground truth file
        gtFile = fullfile(dataPath, 'joint_positions', action{ai}, vidName, 'joint_positions.mat');
        load(gtFile);
%         gtJoint = reshape(pos_img(:,lut,:), 2*np, []);
        gtJoint = reshape(pos_world(:,lut,:), 2*np, []);
        
        %% system ID of training data
        j = 6;
        rs{count} = sysIdSvd(gtJoint(2*j-1:2*j, :), orderUpperBound);
        count = count + 1;
%         if count==80, keyboard; end

        %% display results
        if visualize3
            figure(3);
%             for i = 1:size(gtJoint, 1)
            for i = 2*j-1:2*j
                plot(gtJoint(i,:), '>--');
                title(sprintf('Test Instance %d',i));
                hold off;
                pause;
            end
        end
        
        %% display on video
        if visualize
            param = config();
            model = param.model(param.modelID);
            np = model.np;
            imgRootPath = fullfile(dataPath, 'images');
            imgPath = fullfile(imgRootPath, action{ai}, vidName);
            imgFile = dir(fullfile(imgPath, '*.png'));
            for i = 1:length(imgFile)
                im = imread(fullfile(imgPath, imgFile(i).name));
                gt = reshape(gtJoint(:, i), 2, []).';
                displayJointInColor(im, gt);
                %         displayJointCompareInColor(im, yt, gt);
%                 displayJointCompareInColor(im, yc, gt);
                pause;
            end
        end
        
    end
end
rs(count:end) = [];

n = length(rs);
D = zeros(n, n);
for i = 1:n
    for j = 1:n
        D(i, j) = rs{i}'*rs{j} / (norm(rs{i}) * norm(rs{j}));
    end
end

imagesc(D);
colorbar;