
 close all; clear;
% 
Poles = GeneratePoles(100);
%%
 rng(0);
 outliers = 5 : 5: 90;

%  Precision = zeros(length(Poles),length(outliers));
 thresh = 0.6;
% for N = 1 : length(Poles)
N = 2;
r = poly(Poles(N,:));
sysOrder = length(Poles(N,:));

n = 100;
a = -fliplr(r(2:end));
Results = struct;


  count = 2;
  precision1 = zeros(count,length(outliers));
  precision_sr = zeros(count, length(outliers));
  
 for cnt = 1 : count
%  for cnt = 1
%  y = zeros(n, 1);
% y(1:sysOrder) = rand(sysOrder, 1);


y = zeros(n, 2);
y(1:sysOrder,:) = rand(sysOrder, 2);
noise = 0.01*randn(2,n)';

Y_noise = cell(1, length(outliers));
Y_estimate_p = cell(1,length(outliers));
Y_estimate_sr = cell(1,length(outliers));
Distance_P = cell(1, length(outliers));
Distance_SR = cell(1,length(outliers));



for ii = sysOrder+1:n

     y(ii,:) = a * y(ii-sysOrder:ii-1,:); % start n = 3
   
end
y1 = y(:,1)/max(y(:,1)); y2 = y(:,2)/max(y(:,2));
y_clean = [y1 y2];

% y_noise = y_clean + noise;
%%

for i = 1 : length(outliers)
     
  y_noise = y_clean + noise;



    
% noiseLevel = 0.1;
% y =  y_clean + noiseLevel * randn(size(y));
ind = randperm(n,outliers(i));
% ind = randperm(n,6);
% ind = randsample(n,noise(i));
y_noise(ind,:) = 3;%outliers
nc = 3;
% Hy = hankel_colfixed(y',nc);

%% Proposed
lamda = 1;
eta = 5; 
cvx_solver Mosek

cvx_begin
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
%% SRPCA
lam1 = 200;
lam2 = 100;
y_hat_sr=SRPCA_e1_e2_clean(y_noise,lam1,lam2,ones(size(y_noise)));
% y_sr = SRPCA_e1_e2_clean(y_noise(:,2),lam1,lam2,ones(size(y_noise(:,2))));
% y_hat_sr = [x_sr y_sr];

%% precision
y_cl = y_clean(ind,:);
y_h_p = y_hat(ind,:);
y_h_sr = y_hat_sr(ind,:);

Distance_p = sqrt((y_h_p(:,1)-y_cl(:,1)).^2 + (y_h_p(:,2)-y_cl(:,2)).^2);
Distance_sr = sqrt((y_h_sr(:,1)-y_cl(:,1)).^2 + (y_h_sr(:,2)-y_cl(:,2)).^2);

% % 
 Inlier_p = length(find(Distance_p < thresh));
 Inlier_sr = length(find(Distance_sr < thresh));

 precision1(cnt,i) = (Inlier_p/length(Distance_p));
 precision_sr(cnt,i) = (Inlier_sr/length(Distance_sr));
 
 Y_estimate_p{1,i} = y_hat;
 Y_noise{1,i} = y_noise;
 
 Y_estimate_sr{1,i} = y_hat_sr;
 
 Distance_P{1,i} = Distance_p;
 Distance_SR{1,i} = Distance_sr;

%  
end
 Results(cnt).estimate = Y_estimate_p;
 Results(cnt).estimate_sr = Y_estimate_sr;
 Results(cnt).noise = Y_noise;
 Results(cnt).clean = y_clean;
 Results(cnt).dis_sr = Distance_SR;
 Results(cnt).dis_p = Distance_P;

end
%   save('precision_p_sr','precision1','precision_sr');
%% figure
% close all
% figure(1)
%  plot(y_noise(:,2), 'x','LineWidth',2);
%  hold on;
%   plot(y_hat(:,2), '+');
%   plot(y_clean(:,2),'o');
% hold off;


% %  
% % % plot3(y(:,1),y(:,2),1:length(y),'*');

% plot3(y_hat(:,1),y_hat(:,2),1:length(y_hat),'+');
% plot3(y_clean(:,1),y_clean(:,2),1:length(y_clean),'o');

%  len = legend ('y_{noisy}', 'y_{estimate}', 'y_{clean}');
%  set(len,'FontSize',15);


%% Plotting precision

Pre1 = mean(precision1,1);
Pre2 = mean(precision_sr,1);

plot(outliers,Pre1,'r-*'), hold on
plot(outliers,Pre2,'y-*');

title('Precision v.s outliers','FontSize',15);







