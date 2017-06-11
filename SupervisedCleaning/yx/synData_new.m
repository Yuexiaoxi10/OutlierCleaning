
close all; clear;
%
Poles = GeneratePoles(100);
%%
rng(0);
outliers = 5 : 5: 90;

%  Precision = zeros(length(Poles),length(outliers));
thresh1 = 0.6;% threshold for accuracy
thresh2 = 2.8; % threshold ofr precision & recall

% for N = 1 : length(Poles)
N = 1;
r = poly(Poles(N,:));
sysOrder = length(Poles(N,:));

n = 100;
a = -fliplr(r(2:end));
Results = struct;

count = 1; % number of initial conditions

Accuracy_p = zeros(count,length(outliers));
Accuracy_sr = zeros(count, length(outliers));


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
    OutlierInd = cell(1, length(outliers));
    
    Precision_P = zeros(length(count),length(outliers));
    Recall_P = zeros(length(count),length(outliers));
    Precision_SR = zeros(length(count),length(outliers));
    Recall_SR = zeros(length(count),length(outliers));
    
    
    for ii = sysOrder+1:n
        
        y(ii,:) = a * y(ii-sysOrder:ii-1,:); % start n = 3
        
    end
    y1 = y(:,1)/max(y(:,1)); y2 = y(:,2)/max(y(:,2)); % Normalized
    y_clean = [y1 y2];
    
    % y_noise = y_clean + noise;
    %%
    
    for i = 1 : length(outliers)
        % for i =1
        fprintf('running outlier iter %d/%d ... \n', i, length(outliers));
        
        y_noise = y_clean + noise;
        
        
        
        
        % noiseLevel = 0.1;
        % y =  y_clean + noiseLevel * randn(size(y));
        ind = randperm(n,outliers(i)); % ground truth for outliers
        % ind = randperm(n,6);
        % ind = randsample(n,noise(i));
        y_noise(ind,:) = 3;%outliers
        nc = 3;
        % Hy = hankel_colfixed(y',nc);
        
        %% Proposed
        
        lamda = 1;
        lam1 = 10;
        lam2 = Inf;
        
        eta = 5;
        cvx_solver gurobi_2
        
        cvx_begin quiet
        variables y_hat(size(y)) outlier_hat(size(noise)) noise_hat(size(noise))
        
        Hy_hat = formHankel_colfixed(y_hat,nc);
        Hnoise_hat = formHankel_colfixed(noise,nc);
        % obj = norm_nuc([Hy Hy_hat]);
        Hy_hat * [a -1]' == 0;
        %  Hnoise_hat * [a -1]' == 0;
        %   Hy_hat' * [a_new ;-1;-1] == 0;
        y_noise-y_hat-outlier_hat-noise_hat == 0;
        
        obj = sum(sum(abs(outlier_hat),2))+ lamda * (sum(sum(noise_hat.*noise_hat)));% y = y_hat + e; e = y-y_hat;
        minimize(obj)
        cvx_end
        %% SRPCA
        
        y_hat_sr=SRPCA_e1_e2_clean_md(y_noise,lam1,lam2,ones(size(y_noise)));
        %  y_hat_sr = y_hat_sr1';
        %  x_sr = SRPCA_e1_e2_clean(y_noise(:,1),lam1,lam2,ones(size(y_noise(:,1))));
        %  y_sr = SRPCA_e1_e2_clean(y_noise(:,2),lam1,lam2,ones(size(y_noise(:,2))));
        %  y_hat_sr = [x_sr y_sr];
        
        %% Accuracy
        y_cl = y_clean(ind,:);
        y_h_p = y_hat(ind,:);
        y_h_sr = y_hat_sr(ind,:);
        
        Distance_p = sqrt((y_h_p(:,1)-y_cl(:,1)).^2 + (y_h_p(:,2)-y_cl(:,2)).^2);
        Distance_sr = sqrt((y_h_sr(:,1)-y_cl(:,1)).^2 + (y_h_sr(:,2)-y_cl(:,2)).^2);
        
        % %
        Inlier_p = length(find(Distance_p < thresh1));
        Inlier_sr = length(find(Distance_sr < thresh1));
        
        
        Accuracy_p(cnt,i) = (Inlier_p/length(Distance_p));
        Accuracy_sr(cnt,i) = (Inlier_sr/length(Distance_sr));
        
        Y_estimate_p{1,i} = y_hat;
        Y_noise{1,i} = y_noise;
        
        Y_estimate_sr{1,i} = y_hat_sr;
        
        Distance_P{1,i} = Distance_p;
        Distance_SR{1,i} = Distance_sr;
        OutlierInd{1,i} = ind;
        
        %% Precision and Recall
        % Supervised outlier remove
        %
        Distance_tot_p = sqrt((y_hat(:,1)-y_noise(:,1)).^2 + (y_hat(:,2)-y_noise(:,2)).^2);
        Inset1 = find(Distance_tot_p >= thresh2); % all detections which is within the threshold distance
        %  Outset1 = find(Distance_tot_p < thresh2); % all detections which is outside of the threshold distance
        TP_p = intersect(ind,Inset1); % Truth Positive, both true in gt and a
        %  FP_P = intersect(ind,Outset1); % False Positive, should in "ind", but in "b" instead
        FP_P = setdiff(Inset1, ind); % In detections, but not in gt
        FN_P = setdiff(ind,Inset1); % in "a" but not in "ind"
        %
        precision_p = length(TP_p)/(length(TP_p) + length(FP_P));
        recall_p = length(TP_p)/(length(TP_p) + length(FN_P));
        Precision_P(cnt,i) = precision_p;
        Recall_P(cnt,i) = recall_p;
        
        %  dbstop if error
        % SRPCA
        Distance_tot_sr = sqrt((y_hat_sr(:,1)-y_noise(:,1)).^2 + (y_hat_sr(:,2)-y_noise(:,2)).^2);
        Inset2 = find(Distance_tot_sr >= thresh2);
        % Outset2 = find(Distance_tot_sr < thresh2);
        TP_sr = intersect(ind,Inset2);
        FP_sr = setdiff(Inset2,ind);
        FN_sr = setdiff(ind,Inset2);
        %
        
        precision_sr = length(TP_sr)/(length(TP_sr) + length(FP_sr));
        recall_sr = length(TP_sr)/(length(TP_sr) + length(FN_sr));
        Precision_SR(cnt,i) = precision_sr;
        Recall_SR(cnt,i) = recall_sr;
        
        
        %
    end
    Results(cnt).estimate_p = Y_estimate_p;
    Results(cnt).estimate_sr = Y_estimate_sr;
    Results(cnt).noise = Y_noise;
    Results(cnt).clean = y_clean;
    Results(cnt).dis_sr = Distance_SR;
    Results(cnt).dis_p = Distance_P;
    Results(cnt).ind = OutlierInd;
    
end



%% Plotting Accuracy
figure(1)
AC1 = mean(Accuracy_p,1);
AC2 = mean(Accuracy_sr,1);

plot(outliers,AC1,'r-*'), hold on
plot(outliers,AC2,'y-*');

title('Accuracy v.s outliers','FontSize',15);
legend('Accuracy-supervised','Accuracy-SRPCA');
xlabel('Number of Outliers','FontSize',15);
ylabel('Accuracy','FontSize',15);

ax = gca;
ax.Color = 'none';


%% Plotting Precision, Recall, Geometric mean
Precision1 = mean(Precision_P,1);
Recall1 = mean(Recall_P,1);
G1_score1 = sqrt(Precision1.* Recall1);

Precision2 = mean(Precision_SR,1);
Recall2 = mean(Recall_SR,1);
G1_score2 = sqrt(Precision2.* Recall2);
%  plot(Precision1(1,:),Recall1(1,:),'r-*'),hold
%  plot(Precision2(1,:),Recall2(1,:),'b-*');


figure(2)
plot(outliers, Precision1,'r-*'),hold on
plot(outliers, Recall1,'y-*');
plot(outliers, Precision2,'b-*');
plot(outliers, Recall2,'g-*');

ylim([0,1]);
title('Precision & Recall','FontSize',15);
legend('Precision-Supervised','Recall-Supervised','Precision-SRPCA','Recall-SRPCA');
xlabel('Number of Outliers','FontSize',15);
ylabel('Values of Precision and Recall','FontSize',15);


figure(3)
plot(outliers, G1_score1,'r-*');
plot(outliers, G1_score2,'b-*');
title('F1 scores');
legend('Supervised','SRPCA','FontSize',15);
xlabel('Number of Outliers','FontSize',15);
ylabel('F1 scores');
%% Plotting estimation data, noisy data, clean data

y_esti_p = Results(1).estimate_p{1, 2};
y_noi  =  Results(1).noise{1, 2};
y_cle  =  Results(1).clean;
%  y_esti_sr = Results(1).estimate_sr{1, 2};

figure(4)
plot(y_esti_p(:,1),'r-*','LineWidth',3,'MarkerSize',10), hold on;
plot(y_noi(:,1),'b-*', 'LineWidth',2);
plot(y_cle(:,1),'c-*','LineWidth',2);
%  plot(y_esti_sr(:,1),'y-*','LineWidth',2);


len = legend('Estimation Data','Noisy Data','Clean Data');
set(len,'FontSize',15);
xlabel('Time','FontSize',15);
title('Estimation Results','FontSize',15);
%% Plotting error
y_esti_err = y_esti_p - y_cle;
y_noi_err = y_noi - y_cle;

figure(5)
plot(y_esti_err(:,1),'r-*','LineWidth',2),hold on;
plot(y_noi_err(:,1),'b-*');
title('Estimation for Errors','FontSize',15);
xlabel('Time','FontSize',15);
ylabel('Values of Errors','FontSize',15);
len1 = legend('Estimation Data','Noisy Data');
set(len1,'FontSize',15);






%% Saving Results
save('Accuracy_p_sr','Accuracy_p','Accuracy_sr');
save('Precision_Recall','Precision_P','Recall_P','Precision_SR','Recall_SR');














