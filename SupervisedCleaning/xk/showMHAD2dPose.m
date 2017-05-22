% show my demo results with Wei's code

close all; dbstop if error;
addpath(genpath('.'));
% addpath(genpath('../../3rdParty'));
param = config();
model = param.model(param.modelID);
np = model.np;
% np = 14;

% fprintf('Description of selected model: %s \n', param.model(param.modelID).description);

%% Edit this part
imgPath = '~/research/data/BerkeleyMHAD/Camera/Cluster01/Cam01/S01/A01/R01';
imgFile = dir(fullfile(imgPath, '*.pgm'));

% get pose detections
poseDir = fullfile('~', 'research', 'code', 'OutlierCleaning', 'expData');
poseFile = fullfile(poseDir, 'mhad_pose_s01a01r01.mat');

load(poseFile);
for i = 1:length(detection)
    im = imread(fullfile(imgPath, imgFile(i).name));
    wei_visualize(im, detection{i}, param);
    pause;
end
