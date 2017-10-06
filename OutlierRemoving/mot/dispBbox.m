
function dispBbox(predict, index)

c = hsv(16);
for i = 1:length(index)
    pred = predict(:,:,i);
    mn = min(pred);
    mx = max(pred);
    rect = [mn, mx-mn+1];
    rectangle('Position',rect, 'EdgeColor',c(index(i),:), 'LineWidth',3);
end

end