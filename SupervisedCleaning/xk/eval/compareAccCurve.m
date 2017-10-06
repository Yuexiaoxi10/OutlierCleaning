% compare accuracy curve
rootPath = '~/research/code/OutlierCleaning';
thresList = 0:2:50;
% load(fullfile(rootPath,'expData','accVectorNoCleaning3d'));
% load(fullfile(rootPath,'expData','accVectorSrpca3d'));
% load(fullfile(rootPath,'expData','accVectorSords3d'));
load(fullfile(rootPath,'expData','accVectorNoCleaning2d'));
load(fullfile(rootPath,'expData','accVectorSords2d'));
load(fullfile(rootPath,'expData','accVectorSrpca2d'));
figure(2);
plot(thresList, accVectorNoCleaning, '*-');
hold on;
% plot(thresList, accVectorHstln, '*-');
plot(thresList, accVectorSrpca, '*-');
plot(thresList, accVectorSords, '*-');
hold off;
legend('Without cleaning','SRPCA','SORDS');
title('Accuracy curve');
xlabel('threshold (unit: pixels)');
ylabel('accuracy');
hold off;
aucNoCleaning
aucSrpca
aucSords
