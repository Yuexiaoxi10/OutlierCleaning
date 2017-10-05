function feat = getFeature(img, loc, winSize)

h = size(img, 1);
w = size(img, 2);
d = size(img, 3);

loc = round(loc);
x1 = min(w, max(1, loc(1) - winSize));
x2 = min(w, max(1, loc(1) + winSize));
y1 = min(h, max(1, loc(2) - winSize));
y2 = min(h, max(1, loc(2) + winSize));
roi = img(y1:y2, x1:x2, :);

nBin = 16;
edges = (0:16:256);
feat = zeros(d*nBin, 1);
for i = 1:d
    v = roi(:,:,i);
    feat((i-1)*nBin+1:i*nBin) = histcounts(v(:), edges);
end

end