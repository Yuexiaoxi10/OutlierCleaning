addpath(genpath('../../3rdParty'));
addpath(genpath('../../OutlierRemoving'));
order = 2;
lambda = 1;

NewTraj = getNewTraj(videoPrediction,order,lambda);
