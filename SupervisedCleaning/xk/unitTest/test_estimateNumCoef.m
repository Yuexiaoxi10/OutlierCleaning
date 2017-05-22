% unit test of function estimateNumCoef

num = [1 0];
den = poly([0.3+0.5j, 0.3-0.5j, 0.1+0.8j, 0.1-0.8j]);
c = estimateNumCoef(num, den);

