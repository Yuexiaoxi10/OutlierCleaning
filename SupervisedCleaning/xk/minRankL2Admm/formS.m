% form structure operator
function S = formS(nRow, nCol)

len = nRow + nCol - 1;
index = 1:len;
H = hankel(index(1:nRow), index(nRow:len));
h = H(:);
S = zeros(nRow*nCol, len);
[val, ind] = sort(h);
S(ind+(val-1)*nRow*nCol) = 1;

end