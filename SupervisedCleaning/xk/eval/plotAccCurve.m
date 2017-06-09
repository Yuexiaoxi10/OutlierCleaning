function accVector = plotAccCurve(yc, gt)

thresList = 0:2:50;
accVector = length(thresList);
for i = 1:length(thresList)
    accVector(i) = computeAccuracy(yc, gt, thresList(i));
end
figure(2);
plot(thresList, accVector, '*-');
title('accuracy curve');
xlabel('threshold');
ylabel('accuracy');
