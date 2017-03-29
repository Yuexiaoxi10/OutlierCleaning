% test real data, MHAD as example

addpath(genpath('../matlab'));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

A = data(label_act == 1);
n = length(A);
ys = cell(1, n);
for i = 1:n
    ys{i} = A{i}(1:3,:); % get the first joint
end
ys = getVelocity(ys);

A2 = data(label_act == 3);
n2 = length(A2);
ys2 = cell(1, n2);
for i = 1:n2
    ys2{i} = A2{i}(1:3,:); % get the first joint
end
ys2 = getVelocity(ys2);

rng(0);
index = randperm(n);
m = round(n/2);
trainInd = index(1:m);
testInd = index(m+1:end);
ys_train = ys(trainInd);
ys_test = ys(testInd);



opt.metric = 'JBLD';
opt.H_rows = 6;
opt.H_structure = 'HtH';
opt.sigma = 1e-4;

HH = getHH(ys_train, opt);

HH_center = steinMean(cat(3, HH{1:end}));

% get regressor
[U,S,V] = svd(HH_center);
s = diag(S)
r = U(:, end);


cvx_solver mosek
% outlier cleaning
% ys_test = ys2;
e = zeros(1, length(ys_test));
for i = 1:length(ys_test)
y = ys_test{i};
nc = opt.H_rows;
cvx_begin quiet
variables y_hat(size(y))
% [Hy_hat,S] = formHankel_colfixed(y_hat, nc);
Hy_hat = blockHankel(y_hat, [size(y_hat, 2)-nc+1, nc]);
Hy_hat * r == 0;
obj = norm(y-y_hat, 1);% y = y_hat + e; e = y-y_hat; 
minimize(obj)
cvx_end

e(i) = norm(y-y_hat)
end

% plot(y(1,:),y(2,:), 'x-');
% hold on;
% plot(y_hat(1,:),y_hat(2,:), 'o-');
% hold off;
% legend y_{noisy} y_{estimate}