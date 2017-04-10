% test SRPCA

addpath('../../3rdParty/2DSRPCA');
addpath(genpath('../../matlab'));

clf; clear;

dbstop if error

rng(0);
data_generation;

nLevel = 0.2;
x = data(1:2,1:100);
x2 = x + nLevel * 2*(rand(size(x))-0.5);

lambda = 10;
mask = ones(1, size(x2, 2));
X2 = [blockHankel(x2(1,:));blockHankel(x2(2,:))];
[Jopt, Topt, valCost, rankEst, aopt, eopt]=rHPCA_weight_reweighted_simpler_2D(X2,lambda,mask);
x2_est = reshape(aopt, [], 2)';

% plot(x);
figure(1);
hold on;
plot(x2(1,:), x2(2,:), '*-');
plot(x2_est(1,:),x2_est(2,:), 'o-');
hold off;
