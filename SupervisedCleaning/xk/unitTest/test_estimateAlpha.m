% unit test of function estimateAlpha

alphaGT = 1.2;
r1 = 0.5;
theta1 = 1;
r2 = r1 ^ alphaGT;
theta2 = theta1 * alphaGT;
p1 = [r1*exp(1j*theta1); r1*exp(-1j*theta1)];
p2 = [r2*exp(1j*theta2); r2*exp(-1j*theta2)];
alpha = estimateAlpha(p1, p2);
assert(alpha==alphaGT);