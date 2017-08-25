function [accVector, auc] = plotAccCurve3d(yc, gt)

thresList = 0:2:50;
accVector = length(thresList);
for i = 1:length(thresList)
    accVector(i) = computeAccuracy3d(yc, gt, thresList(i));
end
auc = sum(accVector) * 2 / 50;

figure(2);
plot(thresList, accVector, '*-');
title('accuracy curve');
xlabel('threshold');
ylabel('accuracy');
