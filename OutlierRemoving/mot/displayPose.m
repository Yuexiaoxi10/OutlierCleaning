% display pose

addpath(genpath('../matlab'));
param = config();
load ~/research/code/extern/convolutional-pose-machines-release/testing/python/pred.mat
im = imread('~/research/code/extern/convolutional-pose-machines-release/testing/sample_image/frame0181.png');

wei_visualize(im, prediction, param);
