% load('./Results/Precision_Recall.mat');
%% Computing F1 score
Pre1 = mean(Precision_P,1);
Rec1 = mean(Recall_P,1);
F1_1 = sqrt(Pre1.*Rec1);


Pre2 = mean(Precision_SR,1);
Rec2 = mean(Recall_SR,1);
F1_2 = sqrt(Pre2.*Rec2);

%%
close all
figure(3)
plot(outliers, F1_1,'r-*'), hold on
plot(outliers, F1_2,'y-*');
title('F1 scores','FontSize',15);
legend('Supervised Outlier Remove','SRPCA');
xlabel('Number of Outliers','FontSize',15);
ylabel('F1 scores','FontSize',15);

