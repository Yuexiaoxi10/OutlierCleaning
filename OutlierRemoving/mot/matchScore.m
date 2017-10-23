function score = matchScore(poseTracklet, person, fr, opt)

max_dist = norm([1088,1920])/8;
score = inf(numel(poseTracklet),1);
nTrack = length(poseTracklet);
for i = 1:nTrack
    if poseTracklet(i).tEnd ~= (fr - 1)
        continue;
    end
    loc1 = cat(1,poseTracklet(i).frame(end).joint.xy);
    loc2 = cat(1,person.joint.xy);
    locDist = norm(loc1 - loc2)./max_dist;
    appr1 = cat(1,poseTracklet(i).frame(end).joint.appr);
    appr1 = appr1./sum(appr1);
    appr2 = cat(1,person.joint.appr);
    appr2 = appr1./sum(appr2);
    apprDist = norm(appr1 - appr2);
    cost = locDist + opt.lambda * apprDist;
    if cost < opt.costThres
        score(i) = cost;
    end
end