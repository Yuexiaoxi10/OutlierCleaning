function poseTracklet = associatePose(poseDet, opt)
% this function connect pose detections into short tracklets according to
% location neighborhood
% TODO: make the connection also affected by appearance similarity

poseTracklet = struct('frame',{}, 'traj',{}, 'tStart',{}, 'tEnd',{}, ...
    'length', {}, 'fMiss', {});
nTracklet = 0;
for i = 1:length(poseDet)
    person = poseDet(i).person;
    if isempty(person)
        continue;
    end
    nPerson = length(person);
    % data assoiate table
    table = inf(numel(poseTracklet),nPerson);
    % flags for detection/tracklets 0--not assigned yet
    flag_person = zeros(1,nPerson);
    flag_track = zeros(1,numel(poseTracklet));
    for k = 1:nPerson
%         [idx, leastErr] = matchTracket(poseTracklet, person(k), i, opt);
        table(:,k) = matchScore(poseTracklet,person(k), i, opt);
%         table(idx,k) = leastErr;
    end
    
    % data association
    for t = 1:numel(poseTracklet)
        if all(isinf(table(t,:))) % all detections have been picked
            continue;
        end
        [~,match_idx] = min(table(t,:));
        table(:,match_idx) = inf;
        flag_person(match_idx) = 1;
        flag_track(t) = 1;
        % update tracklets
        poseTracklet(t) = addPose(poseTracklet(t), person(match_idx));
    end
    
    % add new tracklet
    if ~all(flag_person)
        new_idx = find(flag_person==0);
        for n = new_idx
            nTracklet = nTracklet + 1;
            traj = cat(1, person(n).joint.xy);
            poseTracklet(nTracklet) = struct('frame',person(n), ...
                'traj',traj, 'tStart',i, 'tEnd',i, 'length', 1,'fMiss',0);
        end
    end
    
    % taking care missing targets, deleting if missing for a long time
    Th_miss = 1;
    if ~all(flag_track)
        miss_idx = find(flag_track == 0);
        for m = miss_idx
            poseTracklet(m).fMiss = poseTracklet(m).fMiss + 1;
            if poseTracklet(m).fMiss <= Th_miss
                poseTracklet(m).tEnd = poseTracklet(m).tEnd + 1;
            end
        end
    end
    
%     if idx > 0
%         poseTracklet(idx) = addPose(poseTracklet(idx), person(k));
%     else
%         nTracklet = nTracklet + 1;
%         traj = cat(1, person(k).joint.xy);
%         poseTracklet(nTracklet) = struct('frame',person(k), ...
%             'traj',traj, 'tStart',i, 'tEnd',i, 'length', 1);
%     end
end

end