function poseTracklet = associatePose(poseDet, opt)
% this function connect pose detections into short tracklets according to
% location neighborhood
% TODO: make the connection also affected by appearance similarity

poseTracklet = struct('frame',{}, 'traj',{}, 'tStart',{}, 'tEnd',{}, 'length', {});
nTracklet = 0;
for i = 1:length(poseDet)
    person = poseDet(i).person;
    if isempty(person)
        continue;
    end
    nPerson = length(person);
    for k = 1:nPerson
        [idx, leastErr] = matchTracket(poseTracklet, person(k), i, opt);
        if idx > 0
            poseTracklet(idx) = addPose(poseTracklet(idx), person(k));
        else
            nTracklet = nTracklet + 1;
            traj = cat(1, person(k).joint.xy);
            poseTracklet(nTracklet) = struct('frame',person(k), ...
                'traj',traj, 'tStart',i, 'tEnd',i, 'length', 1);
        end
    end
end

end