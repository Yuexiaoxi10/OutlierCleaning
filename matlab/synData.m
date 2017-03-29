
close all; clear;

Poles = GeneratePoles(100);
% Poles(1,:) = [exp(1j*pi/4), exp(-1j*pi/4)];
 noise = 1 : 5: 90;

 Precision = zeros(length(Poles),length(noise));
 thresh = 1e-03;
% thresh = 0.01;
% for N = 1 : length(Poles)
N = 1;
r = poly(Poles(N,:));
sysOrder = length(Poles(N,:));

n = 100;
a = -fliplr(r(2:end));


%%
% cnt = 0; 
precision1 = zeros(200,length(noise));
for cnt = 1 : 200
%  y = zeros(n, 1);
% y(1:sysOrder) = rand(sysOrder, 1);


y = zeros(n, 2);
 y(1:sysOrder,:) = rand(sysOrder, 2);



%initialize
% y_t1 = rand(2,2);
% y(1,:) = a*y_t1;

% start = 3;

for ii = sysOrder+1:n

     y(ii,:) = a * y(ii-sysOrder:ii-1,:); % start n = 3
   
end

y_clean = y;
%%
for i = 1 : length(noise)
y = y_clean;

 rng(0);

    
% noiseLevel = 0.1;
% y =  y_clean + noiseLevel * randn(size(y));
% ind = randi([1, 100], 1, noise(i));
ind = randperm(100, noise(i));
y(ind,:) = 3;%outliers
nc = 3;
% Hy = hankel_colfixed(y',nc);

%%
eta = 5; 
cvx_begin
variables y_hat(size(y))
%s=[]; s*y_hat;reshape

[Hy_hat,S] = formHankel_colfixed(y_hat,nc);
% obj = norm_nuc([Hy Hy_hat]);
 Hy_hat * [a -1]' == 0;
%   Hy_hat' * [a_new ;-1;-1] == 0;
obj = norm(y-y_hat, 1);% y = y_hat + e; e = y-y_hat; 
minimize(obj)
cvx_end
%% precision
y_cl = y_clean(ind,:);
y_h = y_hat(ind,:);
Distance = sqrt((y_h(:,1)-y_cl(:,1)).^2 + (y_h(:,2)-y_cl(:,2)).^2);
% % 
 Inlier = length(find(Distance < thresh));


 precision1(cnt,i) = (Inlier/length(Distance));
end
% cnt = cnt + 1;
 end
%% figure
% close all
% figure(1)
%  plot(y(:,2), 'x','LineWidth',2);
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









