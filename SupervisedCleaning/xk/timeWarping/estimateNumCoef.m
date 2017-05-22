function [c, p] = estimateNumCoef(num, den)
% estimate numerator coefficients

assert(isrow(num));
assert(isrow(den));

syms x
num_pwr = (length(num)-1:-1:0)';
den_pwr = (length(den)-1:-1:0)';
y = (num * x.^num_pwr) / (den * x.^den_pwr);
pm = partfrac(y,'FactorMode','complex');
[num2, den2] = numden(children(pm));
n = length(den2);
p = zeros(n, 1);
c = zeros(n, 1);
for i = 1:n
    den_pm = sym2poly(den2(i));
    p(i) = roots(den_pm);
    c(i) = double(num2(i)) / den_pm(1);
end

end