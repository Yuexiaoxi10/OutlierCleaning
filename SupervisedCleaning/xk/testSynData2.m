 close all; clear;
% 
% Poles = GeneratePoles(100);
% 
% rng(0);
% N = 2;
% r = poly(Poles(N,:));
% sysOrder = length(Poles(N,:));
% 
% n = 100;
% a = -fliplr(r(2:end));

rng(5);
% theta = rand(1,2)*pi; % 0 < theta < 180;
theta1 = [0.1*pi, 0.24*pi];
theta2 = theta1 * 1.2;
p1 = [cos(theta1(1))+1j*sin(theta1(1));cos(theta1(1))-1j*sin(theta1(1)); ...
    cos(theta1(2))+1j*sin(theta1(2)); cos(theta1(2))-1j*sin(theta1(2))];
p2 = [cos(theta2(1))+1j*sin(theta2(1));cos(theta2(1))-1j*sin(theta2(1)); ...
    cos(theta2(2))+1j*sin(theta2(2)); cos(theta2(2))-1j*sin(theta2(2))];

sysOrder = length(p1);
noiseLevel = 0.1;

r1 = poly(p1);
r2 = poly(p2);

a1 = -fliplr(r1(2:end));
a2 = -fliplr(r2(2:end));
N = 100;
y1 = zeros(N, 1);
y1(1:sysOrder) = rand(sysOrder,1);
for i = sysOrder+1:N
    y1(i) = a1 * y1(i-sysOrder:i-1);
end
y1 = y1 / norm(y1, inf);
y1_clean = y1;
y1 = y1_clean + 0*randn(size(y1));

y2 = zeros(N, 1);
y2(1:sysOrder) = rand(sysOrder,1);
for i = sysOrder+1:N
    y2(i) = a2 * y2(i-sysOrder:i-1);
end
y2 = y2 / norm(y2, inf);
y2_clean = y2;
y2 = y2_clean + noiseLevel*randn(size(y2));


figure(1); plot(y1); hold on; plot(y2); hold off;

Hy1 = hankel(y1(1:5), y1(5:end));
[U1,S1,V1] = svd(Hy1);
r1est = U1(:, end);
p1est = roots(flipud(r1est));
[~, ind1] = sort(angle(p1est));
p1est = p1est(ind1);

Hy2 = hankel(y2(1:5), y2(5:50));
[U2,S2,V2] = svd(Hy2);
r2est = U2(:, end);
p2est = roots(flipud(r2est));
[~, ind2] = sort(angle(p2est));
p2est = p2est(ind2);

log(p1est)
log(p2est)./log(p1est)
alpha = abs(mean(log(p2est)./log(p1est)))


p2dtw = p1.^(alpha);
r2dtw = flipud(poly(p2dtw)');

% Proposed
lambda = 1000;
nc = sysOrder+1;
[y2_hat,o_hat,n_hat] = method_l1l2(y2', r2dtw, nc, lambda);

figure(3);
plot(y2_clean, 'x-');
hold on;
% plot(y_hat, 'o-');
plot(y2_hat, 'square-');
xlabel('t');
ylabel('y2');
title('Ex1: data cleaning of the warpped signal, w1=[0.1*pi,0.24*pi], w2=[0.12*pi,0.28*pi]');
hold off;
legend('y2 ground truth', 'y2 cleaned')