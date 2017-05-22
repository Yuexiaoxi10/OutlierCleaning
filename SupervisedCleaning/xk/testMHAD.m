% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';

addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

A1 = data(label_act == 1);
n = length(A1);
ys1 = cell(1, n);
for i = 1:n
    ys1{i} = A1{i}(3,30:end-30); % get the first joint
end
ys1 = getVelocity(ys1);

A2 = data(label_act == 2);
n2 = length(A2);
ys2 = cell(1, n2);
for i = 1:n2
    ys2{i} = A2{i}(3,30:end-30); % get the first joint
end
ys2 = getVelocity(ys2);

% % clean the data with HSTLN
% rk = 6;
% for i = 1:length(ys1)
% %     figure(1);plot(ys1{i},'*-'); hold on;
%     ys1{i} = hstln_mo(ys1{i}, rk);
% %     plot(ys1{i},'*-'); hold off; pause;
% end
% for i = 1:length(ys2)
% %     figure(1);plot(ys2{i},'*-'); hold on;
%     ys2{i} = hstln_mo(ys2{i}, rk);
% %     plot(ys2{i},'*-'); hold off; pause;
% end

% time warping with FFT
% [ys, w0] = fftAlign(ys);
% [ys2, w0] = fftAlign(ys2, w0);
% for i=1:length(ys),
% %     plot(ys{i}); 
%     plot(abs(fft(ys{i},1000)))
%     hold on;
% end, hold off;

rng(0);
index = randperm(n);
m = round(n/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys1_train = ys1(trainInd);
ys1_test = ys1(testInd);
% ys_train = ys(3); % ys_train{1} = ys_train{1}(1:60);
% ys_test = ys(3);% ys_test{1} = ys_test{1}(61:end);

index = randperm(n2);
m = round(n2/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys2_train = ys2(trainInd);
ys2_test = ys2(testInd);
% ys_test = ys2(testInd);

% system ID
order = 4;
y = ys1_train{2}';
u = zeros(size(y)); u(1) = 1;
dat = iddata([zeros(order,1);y], [zeros(order,1); u], 1);
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
% lsim(systf, dat.u, 0:length(dat.u)-1);
% hold on; plot(dat.y,'*-'); hold off;
[coef1, p1train] = estimateNumCoef(systf.num{1}, systf.den{1});
[p1train, ind] = sortPole(p1train);
coef1 = coef1(ind);

y = ys2_train{2}';
u = zeros(size(y)); u(1) = 1;
dat = iddata([zeros(order,1);y], [zeros(order,1); u], 1);
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
% lsim(systf, dat.u, 0:length(dat.u)-1);
% hold on; plot(dat.y,'*-'); hold off;
[coef2, p2train] = estimateNumCoef(systf.num{1}, systf.den{1});
[p2train, ind] = sortPole(p2train);
coef2 = coef2(ind);

% opt.metric = 'JBLD';
% opt.H_rows = 5;
% opt.H_structure = 'HtH';
% opt.sigma = 1e-4;
% 
% [HH1, H1] = getHH(ys1_train, opt);
% HH1_center = steinMean(cat(3, HH1{1:end}));
% % [U1,S1,V1] = svd(HH1_center);
% [U1,S1,V1] = svd(H1{2});
% % s = diag(S)
% r1 = V1(:, end);
% 
% 
% [HH2, H2] = getHH(ys2_train, opt);
% HH2_center = steinMean(cat(3, HH2{1:end}));
% % [U2,S2,V2] = svd(HH2_center);
% [U2,S2,V2] = svd(H2{2});
% % s = diag(S)
% r2 = V2(:, end);

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

% p1train = roots(flipud(r1));
% p2train = roots(flipud(r2));
% p1train = sortPole(p1train);
% p2train = sortPole(p2train);

% outlier cleaning
% ys_test = ys;
% ys_test = ys2;
ys_test = ys1_test;
e1 = zeros(1, length(ys_test));
e2 = zeros(1, length(ys_test));
for i = 1:length(ys_test)
% for i = 2:5
y = ys_test{i};
% y = ys1_train{i};
% y = y / norm(y);
% y = hstln_mo(y,6);
yc1_test = hstln_mo(y, order);

% FFT
% [~, w] = fftAlign(ys_test(i));
% alpha1 = w / w1;
% p1dtw = p1.^(alpha1);
% r = flipud(poly(p1dtw)');
% alpha2 = w / w2;
% p2dtw = p2.^(alpha2);
% r2 = flipud(poly(p2dtw)');

p1test = estimatePole(yc1_test(1:50), order);
p1test = sortPole(p1test);

alpha1 = estimateAlpha(p1train, p1test);
p1testTW = p1train .^ alpha1;
r1testTW = -fliplr(poly(p1testTW))';

alpha2 = estimateAlpha(p2train, p1test);
p2testTW = p2train;
ind = (abs(imag(p2train))>eps);
p2testTW(ind) = p2train(ind) .^ alpha2;
r2testTW = -fliplr(poly(p2testTW))';

nc = order + 1;
% y_hat = method_l2(y, r, nc);
% y2_hat = method_l2(y, r2, nc);

% Proposed
lambda = 10;
% [y_hat,o_hat,n_hat] = sords_l1l2(y, r1testTW, nc, lambda);
% [y_hat] = sords_l2(y, r1testTW, nc);
% [y2_hat] = sords_l2(y, r2testTW, nc);
% y2_hat = method_l1l2(y, r2testTW, nc, lambda);
[y_hat] = sords_l2_lagrangian(y, r1testTW, nc, lambda);
[y2_hat] = sords_l2_lagrangian(y, r2testTW, nc, lambda);

e1(i) = norm(y-y_hat)
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
% nnz(e1-e2<0) / length(e1)

% plot(y(1,:),y(2,:), 'x-');
% hold on;
% plot(y_hat(1,:),y_hat(2,:), 'o-');
% hold off;
% legend y_{noisy} y_{estimate}

