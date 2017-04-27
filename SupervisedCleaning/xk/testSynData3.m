close all; clear;

sysOrder = 4;
N = 100;
noiseLevel = 0.1;

rng(0);
% Generate model
% theta = rand(1,2)*pi; % 0 < theta < 180;
theta1 = [0.1*pi, 0.24*pi];
theta2 = theta1 * 1.2;
p1 = [cos(theta1(1))+1j*sin(theta1(1));cos(theta1(1))-1j*sin(theta1(1)); ...
    cos(theta1(2))+1j*sin(theta1(2)); cos(theta1(2))-1j*sin(theta1(2))];
p2 = [cos(theta2(1))+1j*sin(theta2(1));cos(theta2(1))-1j*sin(theta2(1)); ...
    cos(theta2(2))+1j*sin(theta2(2)); cos(theta2(2))-1j*sin(theta2(2))];
r1 = -fliplr(poly(p1))';
r2 = -fliplr(poly(p2))';

% generate signal 2
y2 = zeros(1, N);
y2(1:sysOrder) = rand(sysOrder,1);
for i = sysOrder+1:N
    y2(i) = y2(i-sysOrder:i-1) * r2(1:end-1);
end
y2 = y2 / norm(y2, inf);
y2_clean = y2;
y2 = y2_clean + noiseLevel*randn(size(y2));

% estimate poles of y2
p2est = estimatePole(y2(1:50), 4);

% sort estimated poles of the known model
p1 = sortPole(p1);
p2 = sortPole(p2);

% sort estimated poles of y2
p2est = sortPole(p2est);

% display the ratio of the sorted poles
log(p2est)./log(p1)

% estimate the ratio as the mean of ratios
alpha = estimateAlpha(p1, p2est);

% get warpped poles of y2 from poles of the known model
p2dtw = p1.^(alpha);

% get the warpped regressor of y2
r2dtw = -fliplr(poly(p2dtw))';

% Proposed method to clean the data
lambda = 1000;
nc = sysOrder+1;
[y2_hat,o_hat,n_hat] = method_l1l2(y2, r2dtw, nc, lambda);

% display the results
figure(3);
plot(y2_clean, 'x-');
hold on;
% plot(y_hat, 'o-');
plot(y2_hat, 'square-');
xlabel('t');
ylabel('y2');
title('Ex2: data cleaning of the warpped signal, w1=[0.1*pi,0.24*pi], w2=[0.12*pi,0.28*pi]');
hold off;
legend('y2 ground truth', 'y2 cleaned')