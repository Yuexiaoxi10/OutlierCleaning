function poseTrackOut = normalizePose(poseTrack)
% Input:
% poseTrack: d x n matrix, d = # of joints * 2, n is # of frames
% Output:
% pose track with each frame centered at the torso

poseTrackOut = poseTrack;
d = size(poseTrack, 1);
n = size(poseTrack, 2);
np = d / 2;
assert(np == 14);
for i = 1:n
    leftHip = poseTrack(9*2-1:9*2, i);
    rightHip = poseTrack(12*2-1:12*2, i);
    center = (leftHip + rightHip) / 2;
    temp = kron(ones(np, 1), center);
    poseTrackOut(:, i) = poseTrack(:, i) - temp;
end

end