% test supervised cleaning function

addpath(genpath('.'));

theta1 = pi / 4;
p1 = [exp(theta1*1i); exp(-theta1*1i)];
sysd1 = tf([1 0], poly(p1), -1);
y1 = impulse(sysd1, 100);
y1 = y1';
r1 = flipud(poly(p1)');

theta2 = pi / 3;
p2 = [exp(theta2*1i); exp(-theta2*1i)];
sysd2 = tf([1 0], poly(p2), -1);
y2 = impulse(sysd2, 100);
y2 = y2';
r2 = flipud(poly(p2)');

y = y2;
r = r1;
nc = 3;
L = length(y);
nr = L-nc+1;
cvx_begin quiet
cvx_solver gurobi_2
    variables y_hat(size(y))
    obj = norm(y-y_hat, 1);% y = y_hat + e; e = y-y_hat; 
    Hy_hat = blockHankel(y_hat, [nr, nc]);
    minimize(obj)
    subject to
%     y_hat(1) == y(1);
%     y_hat(2) == y(2);
    Hy_hat * r == 0;
    
cvx_end
e = y-y_hat;

figure(1);
plot(y, 'x-');
hold on;
plot(y_hat, 'o-');
hold off;
legend y y\_hat