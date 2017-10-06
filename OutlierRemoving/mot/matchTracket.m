function [idx, leastCost] = matchTracket(poseTracklet, person, fr, opt)

idx = -1;
leastCost = inf;

if isempty(poseTracklet)
    return;
end


nTrack = length(poseTracklet);
for i = 1:nTrack
    if poseTracklet(i).tEnd ~= (fr - 1)
        continue;
    end
    loc1 = cat(1,poseTracklet(i).frame(end).joint.xy);
    loc2 = cat(1,person.joint.xy);
    locDist = norm(loc1 - loc2);
    appr1 = cat(1,poseTracklet(i).frame(end).joint.appr);
    appr2 = cat(1,person.joint.appr);
    apprDist = norm(appr1 - appr2);
    cost = locDist + opt.lambda * apprDist;
    if cost < leastCost
        leastCost = cost;
        idx = i;
    end
end

if leastCost > opt.costThres
    idx = -1;
end

end