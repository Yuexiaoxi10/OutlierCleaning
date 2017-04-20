close all; clear;
rng(0);
Poles = GeneratePoles(100);
%%
N = 1;
r = poly(Poles(N,:));
sysOrder = length(Poles(N,:));

n = 100;
a = -fliplr(r(2:end));
Results = struct;


y = zeros(n, 2);
y(1:sysOrder,:) = rand(sysOrder, 2);
noiselevel = 0.1;
noise = noiselevel*randn(2,n)';

for ii = sysOrder+1:n

     y(ii,:) = a * y(ii-sysOrder:ii-1,:); % start n = 3
   
end
y1 = y(:,1)/max(y(:,1)); y2 = y(:,2)/max(y(:,2));
y_clean = [y1 y2];

y_noise = y_clean + noise;
ind = randperm(n,6);

y_noise(ind,:) = 3;%outliers
nc = 3;
%%
lamda = 1;
eta = 5; 

cvx_solver mosek
cvx_begin quiet
variables y_hat(size(y)) outlier_hat(size(noise)) noise_hat(size(noise))

Hy_hat = formHankel_colfixed(y_hat,nc);
Hnoise_hat = formHankel_colfixed(noise,nc);
% obj = norm_nuc([Hy Hy_hat]);
 Hy_hat * [a -1]' == 0;
%  Hnoise_hat * [a -1]' == 0;
%   Hy_hat' * [a_new ;-1;-1] == 0;
y_noise-y_hat-outlier_hat-noise_hat == 0;

obj = sum(sum(abs(outlier_hat),2))+ lamda* (sum(sum(noise_hat.*noise_hat)));% y = y_hat + e; e = y-y_hat; 
minimize(obj)
cvx_end


%% figure
close all
figure(2)
 plot(y_noise(:,2), '-x','LineWidth',2);
 hold on;
  plot(y_hat(:,2), '-+');
  plot(y_clean(:,2),'-o');
hold off;
%%


      
















