clear;

addpath('..');

n = 100;
p = [0.95, -0.9];
sys = tf([1, 0], poly(p), 1);
y = impulse(sys, 0:n-1);
y = y';
y1 = y(1:end-10);
y2 = y(11:end);
y = [y1; y2];
y(:, 30:40) = 0;
omega = ones(1, size(y, 2));
omega(30:40) = 0;

lambda = 1e3;
yHat = minRankAdmm(y, lambda, omega);

plot(y', '*-');
hold on;
plot(yHat', 'o-');
hold off;