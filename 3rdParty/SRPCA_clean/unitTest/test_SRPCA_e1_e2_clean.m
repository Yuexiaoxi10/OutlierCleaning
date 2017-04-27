addpath('..');

rng(0);
% Example on outlier cleaning
y = impulse(tf([1 0],[1 -1.414 1],-1), 100);
y_clean = y;
y(randi(100, [1 5])) = 3;
y_hat = SRPCA_e1_e2_clean_md(y,10,1e10,ones(size(y)));
figure(1);plot(y,'*-');hold on;plot(y_hat,'o-'); hold off; legend('y','y\_hat');
assert(norm(y_hat-y_clean)/100<1e-2);

% Example on Gaussian noise cleaning
y = impulse(tf([1 0],[1 -1.414 1],-1), 100);
y_clean = y;
y = y + 0.1 * randn(size(y));
y_hat = SRPCA_e1_e2_clean_md(y,1e10,100,ones(size(y)));
figure(2);plot(y,'*-');hold on;plot(y_hat,'o-'); hold off; legend('y','y\_hat');
assert(norm(y_hat-y_clean)/100<1e-2);