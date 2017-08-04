
A = zeros(4, 29);
B = zeros(10, 29);
% y = gtJoint(5, :);
count = 1;
for i = 20:48
    y = ysTest(5, 1:i);
    y = y - mean(y);
    Hy = hankel(y(1:4),y(4:end));
    Hy = Hy / norm(Hy, 2);
    s = svd(Hy);
    s = s / sum(s);
    cs = cumsum(s);
    rk(count) = nnz(cs < 0.95) + 1;
    A(:, count) = s;
    count = count + 1;
end
plot(rk,'*-');