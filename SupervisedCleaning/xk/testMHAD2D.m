% test real data, MHAD as example

clear; close all;

rootPath = '~/research/code/OutlierCleaning';

addpath(genpath(fullfile(rootPath, 'SupervisedCleaning/xk')));
addpath(genpath(fullfile(rootPath, '3rdParty')));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

%% get data
A = data(label_sub==1 & label_act==1 & label_rep==1);
A = getVelocity(A);

% system ID
y = A{1}(3,:);
[d, n] = size(y);
order = 4;
y = hstln_mo(y, order);

y = y.';
u = zeros(size(y)); u(1,:) = 1;
dat = iddata([zeros(order,d);y], [zeros(order,d); u], 1);
[sys] = ssest(dat, order, 'Ts', 1, 'InitialState','zero','Focus','simulation');
[num,den] = ss2tf(sys.A,sys.B,sys.C,sys.D,1);
systf = tf(num, den, 1);
lsim(systf, dat.u, 0:length(dat.u)-1);
hold on; plot(dat.y,'*-'); hold off;
[~, p1train] = estimateNumCoef(systf.num{1}, systf.den{1});

%% outlier cleaning
% for i = 1:length(ys1_test)
% for i = 1
load(fullfile(rootPath, 'expData', 'mhad_pose_s01a01r01.mat'));
np = 14;
B = zeros(np*2, length(detection));
for i = 1:length(detection)
    temp = detection{i}';
    B(:, i) = temp(:);
end
y = B(10,:);
yc1_test = hstln_mo(y, order);
r1testTW = -fliplr(poly(p1train))';

% Proposed
nc = order+1;
lambda = 10;
%     [y_hat,o_hat,n_hat] = sords_l1l2(y, r1testTW, nc, lambda);
%     [y_hat] = sords_l2(y, r1testTW, nc);
[y_hat] = sords_l2_lagrangian(y, r1testTW, nc, lambda);

figure(1);
plot(y, 'x-');
hold on;
plot(y_hat, 'o-');
%     plot(y2_hat, 'square-');
title(sprintf('Test Instance %d',i));
hold off;

% 55;
%     pause;
% keyboard;
% end
