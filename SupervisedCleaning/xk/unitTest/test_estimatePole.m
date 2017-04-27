% unit test of function esimatePole

% test 1
p = [0.8; 0.5];
sys = tf([1 0], poly(p), -1);
y = impulse(sys, 100);

order = length(p);
pEst = estimatePole(y, order);

p = sort(p);
pEst = sort(pEst);

assert(norm(p-pEst) < 1e-6)

% test 2
p = [0.5+0.3j; 0.5-0.3j];
sys = tf([1 0], poly(p), -1);
y = impulse(sys, 100);

order = length(p);
pEst = estimatePole(y, order);

[~,ind] = sort(angle(p));
p = p(ind);
[~,ind] = sort(angle(pEst));
pEst = pEst(ind);

assert(norm(p-pEst) < 1e-6)