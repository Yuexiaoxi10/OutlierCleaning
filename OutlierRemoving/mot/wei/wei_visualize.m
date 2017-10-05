function wei_visualize(im, predict, param)

model = param.model(param.modelID);
np = model.np;
facealpha = 0.6; % for limb transparency
truncate = zeros(1,np);

imshow(im);
hold on;
if ndims(predict) == 2
    bodyHeight = max(predict(:,2)) - min(predict(:,2));
    if bodyHeight==0, bodyHeight=bodyHeight+30; end
    plot_visible_limbs(model, facealpha, predict, truncate, bodyHeight/30);
    plot(predict(:,1), predict(:,2), 'k.', 'MarkerSize', bodyHeight/32);
elseif ndims(predict) == 3
    for i = 1:size(predict, 3)
        pred = squeeze(predict(:,:,i));
        bodyHeight = max(pred(:,2)) - min(pred(:,2));
        plot_visible_limbs(model, facealpha, pred, truncate, bodyHeight/30);
        plot(pred(:,1), pred(:,2), 'k.', 'MarkerSize', bodyHeight/32);
    end
end
title('Full Pose');

function plot_visible_limbs(model, facealpha, predict, truncate, stickwidth)
    % plot limbs as ellipses
    limbs = model.limbs;
    colors = hsv(length(limbs));

    for p = 1:size(limbs,1) % visibility?
        if(truncate(limbs(p,1))==1 || truncate(limbs(p,2))==1)
            continue;
        end
        X = predict(limbs(p,:),1);
        Y = predict(limbs(p,:),2);

        if(~sum(isnan(X)))
            a = 1/2 * sqrt((X(2)-X(1))^2+(Y(2)-Y(1))^2);
            b = stickwidth;
            t = linspace(0,2*pi);
            XX = a*cos(t);
            YY = b*sin(t);
            w = atan2(Y(2)-Y(1), X(2)-X(1));
            x = (X(1)+X(2))/2 + XX*cos(w) - YY*sin(w);
            y = (Y(1)+Y(2))/2 + XX*sin(w) + YY*cos(w);
            h = patch(x,y,colors(p,:));
            set(h,'FaceAlpha',facealpha);
            set(h,'EdgeAlpha',0);
        end
    end