% test real data, MHAD as example

clear; close all;

addpath(genpath('../matlab'));
addpath(genpath('../3rdParty'));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

A = data(label_act == 1);
n = length(A);
ys = cell(1, n);
for i = 1:n
    ys{i} = A{i}(3,30:end-30); % get the first joint
end
ys = getVelocity(ys);

A2 = data(label_act == 3);
n2 = length(A2);
ys2 = cell(1, n2);
for i = 1:n2
    ys2{i} = A2{i}(3,30:end-30); % get the first joint
end
ys2 = getVelocity(ys2);

[ys, w0] = fftAlign(ys);
[ys2, w0] = fftAlign(ys2, w0);
for i=1:length(ys),
%     plot(ys{i}); 
    plot(abs(fft(ys{i},1000)))
    hold on;
end, hold off;

rng(0);
index = randperm(n);
m = round(n/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys_train = ys(trainInd);
ys_test = ys(testInd);
% ys_train = ys(3); % ys_train{1} = ys_train{1}(1:60);
% ys_test = ys(3);% ys_test{1} = ys_test{1}(61:end);

index = randperm(n2);
m = round(n2/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys2_train = ys2(trainInd);
ys2_test = ys2(testInd);
% ys_test = ys2(testInd);

opt.metric = 'JBLD';
opt.H_rows = 5;
opt.H_structure = 'HtH';
opt.sigma = 1e-4;

[HH, H] = getHH(ys_train, opt);
HH_center = steinMean(cat(3, HH{1:end}));
[U,S,V] = svd(HH_center);
% [U,S,V] = svd(H{1});
% s = diag(S)
r = V(:, end);


[HH2, H2] = getHH(ys2_train, opt);
HH2_center = steinMean(cat(3, HH2{1:end}));
[U2,S2,V2] = svd(HH2_center);
% [U2,S2,V2] = svd(H2{1});
% s = diag(S)
r2 = V2(:, end);

% [~, w1] = fftAlign(ys_train(1));
% [~, w2] = fftAlign(ys2_train(1));
% p1 = roots(flipud(r));
% p2 = roots(flipud(r2));

% % get regressor from ssrrr
% X = cat(1, H{:})';
% epsilon = 1;
% fix = opt.H_rows;
% tol = 1e-4;
% step = 0;
% [r,r_i,T] = call_ssrrr_lp(X,epsilon,fix,tol,step);



% outlier cleaning
% ys_test = ys;
% ys_test = ys2;
% ys_test = ys2_test;
e = zeros(1, length(ys_test));
e2 = zeros(1, length(ys_test));
for i = 1:length(ys_test)
% for i = 32
y = ys_test{i};
% y = y / norm(y);
% [~, w] = fftAlign(ys_test(i));
% alpha1 = w / w1;
% p1dtw = p1.^(alpha1);
% r = flipud(poly(p1dtw)');
% alpha2 = w / w2;
% p2dtw = p2.^(alpha2);
% r2 = flipud(poly(p2dtw)');

nc = opt.H_rows;
% y_hat = method_l2(y, r, nc);
% y2_hat = method_l2(y, r2, nc);

% Proposed
lambda = 1000;
[y_hat,o_hat,n_hat] = method_l1l2(y, r, nc, lambda);
y2_hat = method_l1l2(y, r2, nc, lambda);

e(i) = norm(y-y_hat)
e2(i) = norm(y-y2_hat)
figure(1);
plot(y, 'x-');
hold on;
plot(y_hat, 'o-');
plot(y2_hat, 'square-');
title(sprintf('Test Instance %d',i));
hold off;

% 55;
pause;
% keyboard;
end
nnz(e-e2<0) / length(e)

% plot(y(1,:),y(2,:), 'x-');
% hold on;
% plot(y_hat(1,:),y_hat(2,:), 'o-');
% hold off;
% legend y_{noisy} y_{estimate}

