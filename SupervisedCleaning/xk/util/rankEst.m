function r = rankEst(H, thres)

s = svd(H);
s = s / sum(s);
cs = cumsum(s);
r = nnz(cs < thres) + 1;

end