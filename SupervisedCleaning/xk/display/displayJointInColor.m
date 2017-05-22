function displayJointInColor(im, joints)
% display each joint in different color

figure(1);
imshow(im);
hold on;
n = size(joints, 1);
c = hsv(n);
for i = 1:n
    plot(joints(i, 1), joints(i, 2), 'x', 'Color', c(i,:), 'MarkerSize',10);
end
hold off;

end