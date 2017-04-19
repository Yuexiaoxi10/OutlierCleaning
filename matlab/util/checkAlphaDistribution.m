% test real data, MHAD as example

clear; close all;

addpath(genpath('../../matlab'));
addpath(genpath('../../3rdParty'));

dataPath = '~/research/data/MHAD';
load(fullfile(dataPath, 'MHAD_data_whole.mat'));

actionIndex = 1;
A = data(label_act == actionIndex);
n = length(A);
ys = cell(1, n);
for i = 1:n
    ys{i} = A{i}(3,30:end-30); % get the first joint
end
ys = getVelocity(ys);

rk = 4;
ys_h = cell(1, n);
for i = 1:n
    ys_h{i} = hstln_mo(ys{i}, rk);
%     figure(1);
%     plot(ys{i});
%     hold on;
%     plot(ys_h{i});
%     hold off;
end

alpha = zeros(1, n);

Hy1 = blockHankel(ys_h{1}, [rk+1, length(ys_h{1})-rk]);
[U1,S1,V1] = svd(Hy1);
r1 = U1(:, end);
p1 = roots(flipud(r1));
[~, ind1] = sort(angle(p1));
p1 = p1(ind1);
alpha(1) = 1;

for i = 2:n
    Hy2 = blockHankel(ys_h{i}, [rk+1, length(ys_h{i})-rk]);
    [U2,S2,V2] = svd(Hy2);
    r2 = U2(:, end);
    p2 = roots(flipud(r2));
    [~, ind2] = sort(angle(p2));
    p2 = p2(ind2);
    log(p2)./log(p1)
    alpha(i) = real(mean(log(p2)./log(p1)));
end

plot(alpha, '*-');
xlabel('video index');
ylabel('alpha');
title(sprintf('alpha values estimated from MHAD dataset Action %d (rank %d)',actionIndex,rk))