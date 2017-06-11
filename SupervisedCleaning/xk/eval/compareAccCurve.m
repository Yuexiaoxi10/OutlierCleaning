% compare accuracy curve
rootPath = '~/research/code/OutlierCleaning';
thresList = 0:2:50;
load(fullfile(rootPath,'expData','accVectorSords'));
load(fullfile(rootPath,'expData','accVectorHstln'));
load(fullfile(rootPath,'expData','accVectorSrpca'));
figure(2);
plot(thresList, accVectorSords, '*-');
hold on;
plot(thresList, accVectorHstln, '*-');
plot(thresList, accVectorSrpca, '*-');
legend('SORDS','HSTLN','SRPCA');
title('accuracy curve');
xlabel('threshold');
ylabel('accuracy');
hold off;
