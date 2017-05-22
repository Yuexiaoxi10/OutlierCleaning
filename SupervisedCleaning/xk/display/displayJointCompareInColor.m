function displayJointCompareInColor(im, jNoisy, jClean)
% display each joint in different color

figure(1);
imshow(im);
hold on;
n = size(jNoisy, 1);
c = hsv(n);
for i = 1:n
    plot(jNoisy(i, 1), jNoisy(i, 2), 'x', 'Color', c(i,:), 'MarkerSize',5);
    plot(jClean(i, 1), jClean(i, 2), 'o', 'Color', c(i,:), 'MarkerSize',5);
end
hold off;

end