
function dispBbox(predict, index)

c = hsv(20);
for i = 1:length(index)
    pred = predict(:,:,i);
   % plot(pred(1,1),pred(1,2),'*','Color',c(index(i),:));
    mn = min(pred);
    mx = max(pred);
%     mn = [pred(1,1) - 200,pred(1,2) - 150];
%     mx = [pred(1,1) + 200,pred(1,2) + 150];
    rect = [mn, mx-mn+1];
    rectangle('Position',rect, 'EdgeColor',c(mod(index(i),20)+1,:), 'LineWidth',3);
end

end