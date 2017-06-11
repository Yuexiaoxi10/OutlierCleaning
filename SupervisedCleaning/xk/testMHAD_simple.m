% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';

addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

%% get data
A1 = data(label_act == 1);
n = length(A1);
ys1 = cell(1, n);
for i = 1:n
    ys1{i} = A1{i}(3,30:end-30); % get the first joint
end
ys1 = getVelocity(ys1);


%% clean the data with HSTLN
% rk = 4;
% for i = 1:length(ys1)
% %     figure(1);plot(ys1{i},'*-'); hold on;
%     ys1{i} = hstln_mo(ys1{i}, rk);
% %     plot(ys1{i},'*-'); hold off; pause;
% end

%% split train and test data
rng(0);
index = randperm(n);
m = round(n/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys1_train = ys1(trainInd);
ys1_test = ys1(testInd);
% ys_train = ys(3); % ys_train{1} = ys_train{1}(1:60);
% ys_test = ys(3);% ys_test{1} = ys_test{1}(61:end);

% system ID
y = ys1_train{2};
order = 4;
y = hstln_mo(y, order);
y = y.';
u = zeros(size(y)); u(1) = 1;
dat = iddata([zeros(order,1);y], [zeros(order,1); u], 1);
% opt = n4sidOptions('Focus','simulation','N4Weight','SSARX');
% [sys, x0] = n4sid(dat, order, 'Ts', 1, 'DisturbanceModel', 'none','Form','canonical','InitialState','zero',opt);
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
lsim(systf, dat.u, 0:length(dat.u)-1);
hold on; plot(dat.y,'*-'); hold off;
[coef, p1train] = estimateNumCoef(systf.num{1}, systf.den{1});
[p1train, ind] = sortPole(p1train);
coef = coef(ind);

% %% stein mean model
% % opt.metric = 'JBLD';
% opt.H_rows = 5;
% % opt.H_structure = 'HtH';
% % opt.sigma = 1e-4;
% % [HH1, H1] = getHH(ys1_train, opt);
% % HH1_center = steinMean(cat(3, HH1{1:end}));
% % % [U1,S1,V1] = svd(HH1_center);
% % [U1,S1,V1] = svd(H1{2});
% % r1 = V1(:, end);
% 
% rk = 4;
% yc1_train = hstln_mo(ys1_train{2}, rk);
% H1 = blockHankel(yc1_train, [size(yc1_train,2)-opt.H_rows+1, opt.H_rows]);
% [U1,S1,V1] = svd(H1);
% r1 = V1(:, end);
% 
% p1train = roots(flipud(r1));
% % p2train = roots(flipud(r2));
% p1train = sortPole(p1train);
% % p2train = sortPole(p2train);

%% outlier cleaning
e1 = zeros(1, length(ys1_test));
e2 = zeros(1, length(ys1_test));
for i = 1:length(ys1_test)
% for i = 8
    y = ys1_test{i};
    % y = ys1_train{i};
    % y = y / norm(y);
    
    yc1_test = hstln_mo(y, order);
    
    [p1test,weights] = bal_from_data(yc1_test(1:50), order);
    p1test = p1test(:);
    weights = reshape([weights; weights],[],1);
    weights = weights / sum(weights);
    [p1test, index] = sortPole(p1test);
    weights = weights(index);
    
%     p1test = estimatePole(yc1_test(1:50), order);
%     p1test = sortPole(p1test);
%     weights = abs(coef) / sum(abs(coef));
    
%     weights = weights.^2;
%     weights = weights / sum(weights);

    [alpha1, alpha1s] = estimateAlpha(p1train, p1test);
    alpha1 = weights' * alpha1s;
%     alpha1 = 0.75;
    
    p1testTW = p1train;
    ind = (abs(imag(p1train))>eps);
    p1testTW(ind) = p1train(ind) .^ alpha1;
%     p1testTW = p1train .^ alpha1;
%     p1testTW(2:3) = [0.8+0.6j,0.8-0.6j];
    r1testTW = -fliplr(poly(p1testTW))';
    
    % Proposed
    nc = order+1;
    lambda = 0;
%     [y_hat,o_hat,n_hat] = sords_l1l2(y, r1testTW, nc, lambda);
%     [y_hat] = sords_l2(y, r1testTW, nc);
    
    [y_hat] = sords_l1_lagrangian(y, r1testTW, nc, lambda);
%     y2_hat = sords_l1l2(y, r2testTW, nc, lambda);
    
    e1(i) = norm(y-y_hat);
%     e2(i) = norm(y-y2_hat)
    figure(1);
    plot(y, 'x-');
    hold on;
    plot(y_hat, 'o-');
%     plot(y2_hat, 'square-');
    title(sprintf('Test Instance %d',i));
    hold off;
    
    % 55;
    pause;
%     keyboard;
end
e1