% unit test of sortPole

p = [0.5+0.3j; 0.5-0.3j; 0.8; -1];
pGT = [0.5-0.3j; 0.8; 0.5+0.3j; -1];
pSort = sortPole(p);
assert(norm(pSort-pGT)<1e-6);
