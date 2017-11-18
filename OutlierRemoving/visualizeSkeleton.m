%function visualizeSkeleton(test_image, videoPrediction, param)
function visualizeSkeleton(videoPrediction, param)
model = param.model(param.modelID);
np = model.np;
part_str = model.part_str;
nstage = model.stage;
%im = imread(test_image);
facealpha = 0.6; 
truncate = zeros(1,np);

%imagesc(im);
% imshow(im)
axis equal
axis off
hold on;
bodyHeight = max(videoPrediction(:,2)) - min(videoPrediction(:,2));
plot_visible_limbs(model, facealpha, videoPrediction, truncate, bodyHeight/30);
plot(videoPrediction(:,1), videoPrediction(:,2), 'k.', 'MarkerSize', bodyHeight/32);
% title('Full Pose');
end

function plot_visible_limbs(model, facealpha, videoPrediction, truncate, stickwidth)
    % plot limbs as ellipses
    limbs = model.limbs;
    colors = hsv(length(limbs));

    for p = 1:size(limbs,1) % visibility?
        1;
        
        if(truncate(limbs(p,1))==1 || truncate(limbs(p,2))==1)
            continue;
        end
        X = videoPrediction(limbs(p,:),1);
        Y = videoPrediction(limbs(p,:),2);

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
end


