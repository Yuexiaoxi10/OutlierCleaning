addpath('..');

rng(0);

% generate clean data with order d dynamics
N = 100;
d = 2;
y = impulse(tf([1 0],[1 -1.414 1],-1), (1:d*N));
y = reshape(y, N, d);
y_clean = y;

% Example on outlier cleaning
y(randi(100, [1 5]), :) = 3;
y_hat = SRPCA_e1_e2_clean_md(y,1,1e10,ones(size(y)));
figure(1);plot(y(:,1),y(:,2),'*-');hold on;plot(y_hat(:,1),y_hat(:,2),'o-'); hold off; legend('y','y\_hat');
assert(norm(y_hat-y_clean)/N<1e-2);

% Example on Gaussian noise cleaning
y = y_clean + 0.1 * randn(size(y));
y_hat = SRPCA_e1_e2_clean_md(y,1e10,100,ones(size(y)));
figure(2);plot(y(:,1),y(:,2),'*-');hold on;plot(y_hat(:,1),y_hat(:,2),'o-'); hold off; legend('y','y\_hat');
assert(norm(y_hat-y_clean)/100<1e-2);