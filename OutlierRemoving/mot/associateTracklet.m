function poseTrack = associateTracklet(poseTracklet, np, nFrame)
% associate tracklets into longer tracks
% if there are missing detections, interpolate them

tracks = zeros(2*np, nFrame);
omega = zeros(1, nFrame);
for i = 1:length(poseTracklet)
    tStart = poseTracklet(i).tStart;
    tEnd = poseTracklet(i).tEnd;
    tracks(:, tStart:tEnd) = poseTracklet(i).data;
    omega(:, tStart:tEnd) = 1;
end

% tracks = propagateTrack(tracks, omega);

poseTrack.data = tracks;
poseTrack.tStart = 1;
poseTrack.tEnd = size(tracks, 2);
poseTrack.length = size(tracks, 2);

poseTrack = cleanTracklet(poseTrack);
% poseTrack = cleanTracklet(poseTrack);

end